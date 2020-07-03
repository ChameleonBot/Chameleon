protocol RichTextElementContainer: RichTextContainer {
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

public struct RichTextContainerFilter {
    let include: (RichTextContainer) -> Bool

    public init(include: @escaping (RichTextContainer) -> Bool) {
        self.include = include
    }
}

extension RichTextContainerFilter {
    public static var all: RichTextContainerFilter {
        return .init { _ in true }
    }

    public static var sectionOnly: RichTextContainerFilter {
        return .init { $0 is Message.Layout.RichText.Section }
    }
}

extension Message {
    public func richText(_ filter: RichTextContainerFilter = .sectionOnly) -> [RichTextElement] {
        return blocks
            .compactMap { $0 as? Layout.RichText }
            .flatMap { $0.elements.filter(filter.include) }
            .compactMap { $0 as? RichTextElementContainer }
            .flatMap { $0.richTextElements }
    }
}
