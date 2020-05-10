import Foundation

public protocol RichTextContext { }
extension MessagesSurface: RichTextContext { }

extension LayoutBlockBuilder where Context: RichTextContext {
    public static func richText(block_id: String? = nil, elements: [RichTextContainerBuilder]) -> LayoutBlockBuilder {
        return .init {
            return Message.Layout.RichText(type: Message.Layout.RichText.type, block_id: block_id, elements: elements.map { $0.build() })
        }
    }

    public static func section(block_id: String? = nil, elements: [RichTextElementBuilder<Message.Layout.RichText.Section>]) -> LayoutBlockBuilder {
        return richText(block_id: block_id, elements: [.section(elements: elements)])
    }
    public static func preformatted(block_id: String? = nil, elements: [RichTextElementBuilder<Message.Layout.RichText.Preformatted>]) -> LayoutBlockBuilder {
        return richText(block_id: block_id, elements: [.preformatted(elements: elements)])
    }
    public static func quote(block_id: String? = nil, elements: [RichTextElementBuilder<Message.Layout.RichText.Quote>]) -> LayoutBlockBuilder {
        return richText(block_id: block_id, elements: [.quote(elements: elements)])
    }
    public static func list(block_id: String? = nil, style: Message.Layout.RichText.List.Style, elements: [RichTextListElementBuilder]) -> LayoutBlockBuilder {
        return richText(block_id: block_id, elements: [.list(style: style, elements: elements)])
    }
}

public struct RichTextContainerBuilder {
    let build: () -> RichTextContainer
}

extension RichTextContainerBuilder {
    public static func section(block_id: String? = nil, elements: [RichTextElementBuilder<Message.Layout.RichText.Section>]) -> RichTextContainerBuilder {
        return .init {
            return Message.Layout.RichText.Section(type: Message.Layout.RichText.Section.type, elements: elements.map { $0.build() })
        }
    }
    public static func preformatted(block_id: String? = nil, elements: [RichTextElementBuilder<Message.Layout.RichText.Preformatted>]) -> RichTextContainerBuilder {
        return .init {
            return Message.Layout.RichText.Preformatted(type: Message.Layout.RichText.Preformatted.type, elements: elements.map { $0.build() })
        }
    }
    public static func quote(block_id: String? = nil, elements: [RichTextElementBuilder<Message.Layout.RichText.Quote>]) -> RichTextContainerBuilder {
        return .init {
            return Message.Layout.RichText.Quote(type: Message.Layout.RichText.Quote.type, elements: elements.map { $0.build() })
        }
    }
    public static func list(block_id: String? = nil, style: Message.Layout.RichText.List.Style, indent: Int = 0, elements: [RichTextListElementBuilder]) -> RichTextContainerBuilder {
        return .init {
            return Message.Layout.RichText.List(type: Message.Layout.RichText.List.type, style: style, indent: indent, elements: elements.map { $0.build() })
        }
    }
}

public struct RichTextListElementBuilder {
    let build: () -> Message.Layout.RichText.Section
}

extension RichTextListElementBuilder {
    public static func item(_ elements: [RichTextElementBuilder<Message.Layout.RichText.Section>]) -> RichTextListElementBuilder {
        return .init {
            return Message.Layout.RichText.Section(type: Message.Layout.RichText.Section.type, elements: elements.map { $0.build() })
        }
    }
}
