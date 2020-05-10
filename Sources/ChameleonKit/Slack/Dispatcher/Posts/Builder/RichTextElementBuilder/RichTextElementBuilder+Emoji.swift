public protocol RichTextEmojiContext { }
extension Message.Layout.RichText.Section: RichTextEmojiContext { }
extension Message.Layout.RichText.Quote: RichTextEmojiContext { }

extension RichTextElementBuilder where Context: RichTextEmojiContext {
    public static func emoji(_ value: Emoji) -> RichTextElementBuilder {
        return .init {
            return Message.Layout.RichText.Element.Emoji(type: Message.Layout.RichText.Element.Emoji.type, name: value)
        }
    }
}
