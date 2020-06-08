import Foundation

public struct SlackEvent<Packet> {
    public typealias CanHandle = (_ type: String, _ json: [String: Any]) -> Bool
    public typealias Handler = (_ json: [String: Any]) throws -> Packet

    public let identifier: String
    public let canHandle: CanHandle
    public let handle: Handler

    public init(identifier: String, canHandle: @escaping CanHandle, handler: @escaping Handler) {
        self.identifier = identifier
        self.canHandle = canHandle
        self.handle = handler
    }
}

extension SlackEvent where Packet: Decodable {
    public init(identifier: String, canHandle: @escaping CanHandle) {
        self.init(
            identifier: identifier,
            canHandle: canHandle,
            handler: { json in
                return try Packet(from: json, decoder: JSONDecoder().debug(json))
            }
        )
    }
}
