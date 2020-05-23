public protocol MultiSelectConversationContext { }
extension Message.Layout.Section: MultiSelectConversationContext { }
extension Message.Layout.Input: MultiSelectConversationContext { }

extension BlockElementBuilder where Context: MultiSelectConversationContext {
    public static func multiSelectConversation(action_id: String, placeholder: Text.PlainText, initial_conversations: [Identifier<Conversation>] = [], confirm: Confirmation? = nil, max_selected_items: Int? = nil, filter: ConversationFilter? = nil) -> BlockElementBuilder {
        return .init {
            return MultiConversationSelect(type: MultiConversationSelect.type, placeholder: placeholder, action_id: action_id, initial_conversations: initial_conversations, confirm: confirm, max_selected_items: max_selected_items, filter: filter)
        }
    }
}
