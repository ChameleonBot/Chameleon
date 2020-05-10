public protocol RichTextBroadcastContext { }
extension Message.Layout.RichText.Section: RichTextBroadcastContext { }
extension Message.Layout.RichText.Quote: RichTextBroadcastContext { }

extension RichTextElementBuilder where Context: RichTextBroadcastContext {
    public static func broadcast(_ value: Broadcast) -> RichTextElementBuilder {
        return .init {
            return Message.Layout.RichText.Element.Broadcast(type: Message.Layout.RichText.Element.Broadcast.type, range: value)
        }
    }
}
