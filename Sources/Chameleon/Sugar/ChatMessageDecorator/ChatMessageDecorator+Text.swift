
public extension ChatMessageDecorator {
    @discardableResult
    func text(_ values: [ChatMessageSegmentRepresentable]) -> ChatMessageDecorator {
        let newText = values
            .map { $0.messageSegment }
            .joined(separator: " ")

        text = text + newText

        return self
    }

    @discardableResult
    func newLine() -> ChatMessageDecorator {
        text = text + "\n"
        return self
    }
}
