import Foundation

public class SlackEventHandler {
    struct EventHandler {
        typealias Predicate = (String, [String: Any]) -> Bool
        typealias Processor = ([String: Any]) throws -> Any
        typealias Handler = (Any) -> Void

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
        eventHandler.handlers[id] = { [unowned self] in
            do { try closure($0 as! T) }
            catch let error { self.onError(error) }
        }
        eventHandlers[event.identifier] = eventHandler
        return .init { [weak self] in
            self?.eventHandlers[event.identifier]?.handlers[id] = nil
        }
    }
    public func handle(data: Data) {
        do {
            guard
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let token = json["token"] as? String
                else { throw SlackPacketError.noToken }

            guard token == verificationToken else { throw SlackPacketError.invalidToken }

            guard
                let event = json["event"] as? [String: Any],
                let eventType = event["type"] as? String
                else { throw SlackPacketError.invalidPacket }

            let matchingHandlers = eventHandlers.values.filter { $0.predicate(eventType, event) }
            for eventHandler in matchingHandlers {
                let processed = try eventHandler.processor(event)
                eventHandler.handlers.values.forEach { $0(processed) }
            }

        } catch let error {
            onError(error)
        }
    }
}
