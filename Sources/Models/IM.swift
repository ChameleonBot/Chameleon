
public struct IM {
    public let id: String
    public let is_im: Bool
    public let is_open: Bool
    public let has_pins: Bool
    public let user: ModelPointer<User>
    public let created: Int
    public let is_user_deleted: Bool
    public let last_read: String?
    public let latest: Message?
}

extension IM: Common.Decodable {
    public init(decoder: Common.Decoder) throws {
        self = try decode {
            return IM(
                id: try decoder.value(at: ["id"]),
                is_im: (try? decoder.value(at: ["is_im"])) ?? false,
                is_open: (try? decoder.value(at: ["is_open"])) ?? false,
                has_pins: (try? decoder.value(at: ["has_pins"])) ?? false,
                user: try decoder.pointer(at: ["user"]),
                created: try decoder.value(at: ["created"]),
                is_user_deleted: (try? decoder.value(at: ["is_user_deleted"])) ?? false,
                last_read: try? decoder.value(at: ["last_read"]),
                latest: try? decoder.value(at: ["latest"])
            )
        }
    }
}
