public struct Emoji: Codable, Hashable, RawRepresentable {
    public var rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension Emoji {
    public static var smile: Emoji { .init(rawValue: #function) }
    public static var balloon: Emoji { .init(rawValue: #function) }
}
