public struct Reaction: Codable, Equatable {
    public var name: Emoji
    public var count: Int
    public var users: [Identifier<User>]
}
