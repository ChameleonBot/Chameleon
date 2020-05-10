import Foundation

public protocol RichTextLinkContext { }
extension Message.Layout.RichText.Section: RichTextLinkContext { }
extension Message.Layout.RichText.Quote: RichTextLinkContext { }

extension RichTextElementBuilder where Context: RichTextLinkContext {
    public static func link(text: String? = nil, url: URL) -> RichTextElementBuilder {
        return .init {
            return Message.Layout.RichText.Element.Link(type: Message.Layout.RichText.Element.Link.type, text: text, url: url)
        }
    }
}
