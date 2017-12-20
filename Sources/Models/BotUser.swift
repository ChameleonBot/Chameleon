
public struct BotUser {
    public let id: String
    public let name: String

    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

extension BotUser: Common.Decodable {
    public init(decoder: Common.Decoder) throws {
        self = try decode {
            return BotUser(
                id: try decoder.value(at: ["id"]),
                name: try decoder.value(at: ["name"])
            )
        }
    }
}
