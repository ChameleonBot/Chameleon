
extension ChatMessageSegmentRepresentable {
    /// Place the text in a pre block
    public var pre: ChatMessageSegmentRepresentable {
        return "```\(messageSegment)```"
    }

    /// Use inline code formatting
    public var code: ChatMessageSegmentRepresentable {
        return "`\(messageSegment)`"
    }

    /// Use italics
    public var italic: ChatMessageSegmentRepresentable {
        return "_\(messageSegment)_"
    }

    /// Use bold
    public var bold: ChatMessageSegmentRepresentable {
        return "*\(messageSegment)*"
    }

    /// Use strikethrough
    public var strike: ChatMessageSegmentRepresentable {
        return "~\(messageSegment)~"
    }

    /// Use quote
    public var quote: ChatMessageSegmentRepresentable {
        return ">>>\(messageSegment)"
    }
}
