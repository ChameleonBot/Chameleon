
public struct Channel {
    public let id: String
    public let name: String

    public let created: Int
    public let creator: ModelPointer<User>

    public let members: [ModelPointer<User>]

    public let topic: Topic?
    public let purpose: Purpose?
}

extension Channel: Common.Decodable {
    public init(decoder: Common.Decoder) throws {
        self = try decode {
            return Channel(
                id: try decoder.value(at: ["id"]),
                name: try decoder.value(at: ["name"]),
                created: try decoder.value(at: ["created"]),
                creator: try decoder.pointer(at: ["creator"]),
                members: try decoder.pointers(at: ["members"]),
                topic: try? decoder.value(at: ["topic"]),
                purpose: try? decoder.value(at: ["purpose"])
            )
        }
    }
}
