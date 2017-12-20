
public struct Pong {
    public let timestamp: Int
    public let reply_to: Int
    public var raw: KeyPathAccessible
}

extension Pong: Common.Decodable {
    public init(decoder: Common.Decoder) throws {
        self = try decode {
            return Pong(
                timestamp: try decoder.value(at: ["timestamp"]),
                reply_to: try decoder.value(at: ["reply_to"]),
                raw: decoder.data
            )
        }
    }
}
