public protocol RichTextChannelContext { }
extension Message.Layout.RichText.Section: RichTextChannelContext { }
extension Message.Layout.RichText.Quote: RichTextChannelContext { }

extension RichTextElementBuilder where Context: RichTextChannelContext {
    public static func channel(_ value: Identifier<Channel>) -> RichTextElementBuilder {
        return .init {
            return Message.Layout.RichText.Element.Channel(type: Message.Layout.RichText.Element.Channel.type, channel_id: value)
        }
    }
}
