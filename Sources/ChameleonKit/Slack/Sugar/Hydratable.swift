public protocol Hydratable {
    static func hydrate(with identifier: Identifier<Self>) -> SlackAction<Self>
}

extension User: Hydratable {
    public static func hydrate(with identifier: Identifier<Self>) -> SlackAction<Self> {
        return .user(identifier)
    }
}
extension Channel: Hydratable {
    public static func hydrate(with identifier: Identifier<Self>) -> SlackAction<Self> {
        return .channel(identifier)
    }
}
