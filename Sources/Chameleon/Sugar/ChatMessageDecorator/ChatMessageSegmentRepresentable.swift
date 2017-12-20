
public protocol ChatMessageSegmentRepresentable {
    var messageSegment: String { get }
}
extension ChatMessageSegmentRepresentable {
    public var messageSegment: String { return "\(self)" }
}

extension String: ChatMessageSegmentRepresentable { }
extension Int: ChatMessageSegmentRepresentable { }

extension Emoji: ChatMessageSegmentRepresentable { }
extension CustomEmoji: ChatMessageSegmentRepresentable { }
extension ChatMessageSegmentRepresentable where Self: EmojiRepresentable {
    public var messageSegment: String { return self.emoji }
}

extension Command: ChatMessageSegmentRepresentable {
    public var messageSegment: String { return self.rawValue }
}

extension ChatMessageSegmentRepresentable where Self: TokenRepresentable & IDRepresentable {
    public var messageSegment: String {
        return "<\(Self.token)\(id)>"
    }
}
extension User: ChatMessageSegmentRepresentable { }
extension BotUser: ChatMessageSegmentRepresentable { }
extension Channel: ChatMessageSegmentRepresentable { }
extension Group: ChatMessageSegmentRepresentable { }

//TODO - with conditional conformance I should be able to rewrite this to be something like:
// `extension ModelPointer: ChatMessageSegmentRepresentable where Model: TokenRepresentable {`
extension ModelPointer: ChatMessageSegmentRepresentable {
    public var messageSegment: String {
        let token = (Model.self as? TokenRepresentable.Type)?.token ?? ""
        return "<\(token)\(id)>"
    }
}
