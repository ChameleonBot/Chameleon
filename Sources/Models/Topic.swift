
public struct Topic {
    public let value: String
    public let creator: ModelPointer<User>?
    public let last_set: Int
}

extension Topic: Common.Decodable {
    public init(decoder: Common.Decoder) throws {
        self = try decode {
            return Topic(
                value: try decoder.value(at: ["value"]),
                creator: try? decoder.pointer(at: ["creator"]),
                last_set: try decoder.value(at: ["last_set"])
            )
        }
    }
}
