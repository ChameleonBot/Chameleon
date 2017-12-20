
public struct Team {
    public let id: String
    public let name: String
    public let domain: String
}

extension Team: Common.Decodable {
    public init(decoder: Common.Decoder) throws {
        self = try decode {
            return Team(
                id: try decoder.value(at: ["id"]),
                name: try decoder.value(at: ["name"]),
                domain: try decoder.value(at: ["domain"])
            )
        }
    }
}
