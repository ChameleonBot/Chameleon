public protocol MultiSelectUserContext { }
extension Message.Layout.Section: MultiSelectUserContext { }
extension Message.Layout.Input: MultiSelectUserContext { }

extension BlockElementBuilder where Context: MultiSelectUserContext {
    public static func multSelectUser(action_id: String, placeholder: Text.PlainText, initial_users: [Identifier<User>] = [], confirm: Confirmation? = nil, max_selected_items: Int? = nil) -> BlockElementBuilder {
        return .init {
            return MultiUserSelect(type: MultiUserSelect.type, placeholder: placeholder, action_id: action_id, initial_users: initial_users, confirm: confirm, max_selected_items: max_selected_items)
        }
    }
}
