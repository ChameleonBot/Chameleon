public protocol RichTextUserContext { }
extension Message.Layout.RichText.Section: RichTextUserContext { }
extension Message.Layout.RichText.Quote: RichTextUserContext { }

extension RichTextElementBuilder where Context: RichTextUserContext {
    public static func user(_ value: Identifier<User>) -> RichTextElementBuilder {
        return .init {
            return Message.Layout.RichText.Element.User(type: Message.Layout.RichText.Element.User.type, user_id: value)
        }
    }
}
