protocol RichTextElementContainer {
    var richTextElements: [RichTextElement] { get }
}

extension Message.Layout.RichText.Section: RichTextElementContainer {
    var richTextElements: [RichTextElement] { return elements }
}
extension Message.Layout.RichText.Preformatted: RichTextElementContainer {
    var richTextElements: [RichTextElement] { return elements }
}
extension Message.Layout.RichText.Quote: RichTextElementContainer {
    var richTextElements: [RichTextElement] { return elements }
}
extension Message.Layout.RichText.List: RichTextElementContainer {
    var richTextElements: [RichTextElement] {
        return elements.flatMap { $0.richTextElements }
    }
}
extension Message.Layout.RichText {
    func richTextElements() -> [RichTextElement] {
        return elements
            .compactMap { $0 as? RichTextElementContainer }
            .flatMap { $0.richTextElements }
    }
}

extension Message {
    public func richText() -> [RichTextElement] {
        return blocks
            .compactMap { $0 as? Layout.RichText }
            .flatMap { $0.richTextElements() }
    }
}
