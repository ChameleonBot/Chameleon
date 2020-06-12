import Foundation

public class SlackEventHandler {
    struct EventHandler {
        typealias Predicate = (String, [String: Any]) -> Bool
        typealias Processor = ([String: Any]) throws -> Any
        typealias Handler = ([String: Any], Any) -> Void

        let predicate: Predicate
        let processor: Processor
        var handlers: [String: Handler]
    }

    // MARK: - Private Properties
    private let verificationToken: String
    private var eventHandlers: [String: EventHandler] = [:]

    // MARK: - Public Properties
    public var onError: (Error) -> Void = { _ in fatalError("Error handler not attached") }

    // MARK: - Lifecycle
    public init(verificationToken: String) {
        self.verificationToken = verificationToken
    }

    // MARK: - Public Functions
    @discardableResult
    public func listen<T>(for event: SlackEvent<T>, _ closure: @escaping (T) throws -> Void) -> Cancellable {
        var eventHandler = eventHandlers[event.identifier] ?? EventHandler(predicate: event.canHandle, processor: event.handle, handlers: [:])
        let id = UUID().uuidString
        eventHandler.handlers[id] = { [unowned self] json, value in
            do {
                try closure(value as! T)
                
            } catch let error {
                self.onError(SlackEventError(identifier: event.identifier, event: json, error: error))
            }
        }
        eventHandlers[event.identifier] = eventHandler
        return .init { [weak self] in
            self?.eventHandlers[event.identifier]?.handlers[id] = nil
        }
    }
    public func handle(data: Data) {
        do {
            let jsonPacket = try JSONSerialization.jsonObject(with: data, options: [])

            guard let json = jsonPacket as? [String: Any] else { throw SlackPacketError.invalidPacket(jsonPacket) }
            guard let token = json["token"] as? String else { throw SlackPacketError.noToken(json) }
            guard token == verificationToken else { throw SlackPacketError.invalidToken(json) }

            guard
                let event = json["event"] as? [String: Any],
                let eventType = event["type"] as? String
                else { throw SlackPacketError.invalidPacket(json) }

            let matchingHandlers = eventHandlers.filter { $0.value.predicate(eventType, event) }
            for (identifier, eventHandler) in matchingHandlers {
                do {
                    let value = try eventHandler.processor(event)
                    eventHandler.handlers.values.forEach { $0(event, value) }

                } catch let error {
                    throw SlackEventError(identifier: identifier, event: event, error: error)
                }
            }

        } catch let error {
            onError(error)
        }
    }
}
