import Foundation

public struct SlackEvent<Packet> {
    public typealias Handler = ([String: Any]) throws -> Packet

    public let type: String
    public let handle: Handler

    public init(type: String, handler: @escaping Handler) {
        self.type = type
        self.handle = handler
    }
}

extension SlackEvent where Packet: Decodable {
    public init(type: String) {
        self.type = type
        self.handle = { json in
            return try Packet(from: json, decoder: JSONDecoder().debug(json))
        }
    }
}