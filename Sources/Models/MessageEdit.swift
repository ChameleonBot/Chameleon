
public struct MessageEdit {
    public let user: ModelPointer<User>
    public let ts: String
}

extension MessageEdit: Common.Decodable {
    public init(decoder: Common.Decoder) throws {
        self = try decode {
            return MessageEdit(
                user: try decoder.pointer(at: ["user"]),
                ts: try decoder.value(at: ["ts"])
            )
        }
    }
}
