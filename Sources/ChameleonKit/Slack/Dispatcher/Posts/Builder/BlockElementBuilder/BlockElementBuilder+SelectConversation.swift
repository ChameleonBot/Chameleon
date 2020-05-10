public protocol SelectConversationContext { }
extension Message.Layout.Section: SelectConversationContext { }
extension Message.Layout.Actions: SelectConversationContext { }
extension Message.Layout.Input: SelectConversationContext { }

extension BlockElementBuilder where Context: SelectConversationContext {
    public static func selectConversation(action_id: String, placeholder: Text.PlainText, initial_conversation: Identifier<Conversation>? = nil, confirm: Confirmation? = nil, response_url_enabled: Bool? = nil, filter: ConversationFilter? = nil) -> BlockElementBuilder {
        return .init {
            return SelectConversation(type: SelectConversation.type, placeholder: placeholder, action_id: action_id, initial_conversation: initial_conversation, confirm: confirm, response_url_enabled: response_url_enabled, filter: filter)
        }
    }
}
