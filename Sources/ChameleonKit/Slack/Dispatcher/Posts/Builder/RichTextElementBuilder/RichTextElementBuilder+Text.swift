import Foundation

public protocol RichTextTextContext { }
extension Message.Layout.RichText.Section: RichTextTextContext { }
extension Message.Layout.RichText.Preformatted: RichTextTextContext { }
extension Message.Layout.RichText.Quote: RichTextTextContext { }

extension RichTextElementBuilder where Context: RichTextTextContext {
    public static func text(_ value: String, style: Message.Layout.RichText.Element.Text.Style? = nil) -> RichTextElementBuilder {
        return .init {
            let style = style ?? (try! JSONDecoder().decode(Message.Layout.RichText.Element.Text.Style.self, from: Data("{}".utf8)))
            return Message.Layout.RichText.Element.Text(type: Message.Layout.RichText.Element.Text.type, text: value, style: style)
        }
    }
}
