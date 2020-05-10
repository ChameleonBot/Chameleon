public protocol RichTextUserGroupContext { }
extension Message.Layout.RichText.Section: RichTextUserGroupContext { }
extension Message.Layout.RichText.Quote: RichTextUserGroupContext { }

extension RichTextElementBuilder where Context: RichTextUserGroupContext {
    public static func group(_ value: Identifier<UserGroup>) -> RichTextElementBuilder {
        return .init {
            return Message.Layout.RichText.Element.UserGroup(type: Message.Layout.RichText.Element.UserGroup.type, usergroup_id: value)
        }
    }
}
