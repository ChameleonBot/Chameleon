
public struct User {
    public let id: String
    public let display_name: String
    public let color: String
    public let status_text: String?
    public let first_name: String?
    public let last_name: String?
    public let real_name: String?
    public let email: String?
    public let image: String?
    public let is_admin: Bool
    public let is_owner: Bool
    public let is_bot: Bool
    public let updated: Int
}

extension User: Common.Decodable {
    public init(decoder: Common.Decoder) throws {
        self = try decode {
            return User(
                id: try decoder.value(at: ["id"]),
                display_name: try decoder.value(at: ["profile", "display_name"]),
                color: try decoder.value(at: ["color"]),
                status_text: try? decoder.value(at: ["profile", "status_text"]),
                first_name: try? decoder.value(at: ["profile", "first_name"]),
                last_name: try? decoder.value(at: ["profile", "last_name"]),
                real_name: try? decoder.value(at: ["profile", "real_name"]),
                email: try? decoder.value(at: ["profile", "email"]),
                image: try? decoder.value(at: ["profile", "image_512"]),
                is_admin: (try? decoder.value(at: ["is_admin"])) ?? false,
                is_owner: (try? decoder.value(at: ["is_owner"])) ?? false,
                is_bot: (try? decoder.value(at: ["is_bot"])) ?? false,
                updated: try decoder.value(at: ["updated"])
            )
        }
    }
}
