import Foundation

public struct SlackEvent<Packet> {
    public typealias CanHandle = (String) -> Bool
    public typealias Handler = ([String: Any]) throws -> Packet

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
        self.identifier = identifier
        self.canHandle = canHandle
        self.handle = { json in
            return try Packet(from: json, decoder: JSONDecoder().debug(json))
        }
    }
}
