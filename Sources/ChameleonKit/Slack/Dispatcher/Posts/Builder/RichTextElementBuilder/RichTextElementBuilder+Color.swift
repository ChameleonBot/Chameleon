public protocol RichTextColorContext { }
extension Message.Layout.RichText.Section: RichTextColorContext { }
extension Message.Layout.RichText.Quote: RichTextColorContext { }

extension RichTextElementBuilder where Context: RichTextColorContext {
    public static func color(_ value: Color) -> RichTextElementBuilder {
        return .init {
            return Message.Layout.RichText.Element.Color(type: Message.Layout.RichText.Element.Color.type, value: value)
        }
    }
}
