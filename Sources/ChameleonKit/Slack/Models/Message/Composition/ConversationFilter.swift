public struct ConversationFilter: Codable, Equatable {
    public enum Options: String, Codable, Equatable {
        case im, mpim, `private`, `public`
    }

    public var include: [Options]
    @Default<False> public var exclude_external_shared_channels: Bool
    @Default<False> public var exclude_bot_users: Bool
}
