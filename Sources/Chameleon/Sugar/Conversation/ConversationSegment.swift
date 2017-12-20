
public protocol ConversationSegment: Hashable {
    var message: [ChatMessageSegmentRepresentable] { get }
    var input: [Matcher] { get }
}

extension ConversationSegment {
    private var identifier: String {
        return message.map({ $0.messageSegment }).joined(separator: ":") + input.map({ $0.matcherDescription }).joined(separator: ":")
    }
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    public var hashValue: Int {
        return identifier.hashValue
    }
}
