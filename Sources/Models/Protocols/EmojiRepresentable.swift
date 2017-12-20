
public protocol EmojiRepresentable {
    var emoji: String { get }
}

extension Emoji: EmojiRepresentable {
    public var emoji: String {
        return ":\(self.rawValue):"
    }
}

extension CustomEmoji: EmojiRepresentable {
    public var emoji: String {
        return ":\(self.name):"
    }
}
