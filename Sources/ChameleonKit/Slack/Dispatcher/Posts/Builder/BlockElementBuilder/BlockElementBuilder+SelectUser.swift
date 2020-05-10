public protocol SelectUserContext { }
extension Message.Layout.Section: SelectUserContext { }
extension Message.Layout.Actions: SelectUserContext { }
extension Message.Layout.Input: SelectUserContext { }

extension BlockElementBuilder where Context: SelectUserContext {
    public static func selectUser(action_id: String, placeholder: Text.PlainText, initial_user: Identifier<User>? = nil, confirm: Confirmation? = nil) -> BlockElementBuilder {
        return .init {
            return SelectUser(type: SelectUser.type, placeholder: placeholder, action_id: action_id, initial_user: initial_user, confirm: confirm)
        }
    }
}
