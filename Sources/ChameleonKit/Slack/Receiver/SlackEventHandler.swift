import Foundation

public class SlackEventHandler {
    struct EventHandler {
        typealias Processor = ([String: Any]) throws -> Any
        typealias Handler = (Any) throws -> Void

        let processor: Processor
        var handlers: [Handler]
    }

    // MARK: - Private Properties
    private let verificationToken: String
    private var eventHandlers: [String: EventHandler] = [:]

    // MARK: - Lifecycle
    public init(verificationToken: String) {
        self.verificationToken = verificationToken
    }

    // MARK: - Public Functions
    public func listen<T>(for event: SlackEvent<T>, _ closure: @escaping (T) throws -> Void) {
        var eventHandler = eventHandlers[event.type] ?? EventHandler(processor: event.handle, handlers: [])
        eventHandler.handlers.append({ try closure($0 as! T) })
        eventHandlers[event.type] = eventHandler
    }
    public func handle(data: Data) throws {
        guard
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let token = json["token"] as? String
            else { throw SlackPacketError.noToken }

        guard token == verificationToken else { throw SlackPacketError.invalidToken }

        guard
            let event = json["event"] as? [String: Any],
            let eventType = event["type"] as? String
            else { throw SlackPacketError.invalidPacket }

        if let handler = eventHandlers[eventType] {
            let processed = try handler.processor(event)
            try handler.handlers.forEach { try $0(processed) }
        }
    }
}
