
public protocol RTMAPIEvent {
    associatedtype EventData

    static var eventType: String { get }

    static func handle(packet: [String: Any]) throws -> EventData
}

extension RTMAPIEvent {
    public static var eventType: String { return String(describing: self) }

    static func canMake(from packet: [String: Any]) -> Bool {
        guard let event = packet["type"] as? String else { return false }
        return event == self.eventType
    }
}
