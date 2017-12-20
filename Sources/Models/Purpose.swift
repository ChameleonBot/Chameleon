
public struct Purpose {
    public let value: String
    public let creator: ModelPointer<User>?
    public let last_set: Int
}

extension Purpose: Common.Decodable {
    public init(decoder: Common.Decoder) throws {
        self = try decode {
            return Purpose(
                value: try decoder.value(at: ["value"]),
                creator: try? decoder.pointer(at: ["creator"]),
                last_set: try decoder.value(at: ["last_set"])
            )
        }
    }
}
