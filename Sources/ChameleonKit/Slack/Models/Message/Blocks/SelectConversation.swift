public struct SelectConversation: Codable, Equatable {
    public static let type = "conversations_select"

    public var type: String
    public var placeholder: Text.PlainText
    public var action_id: String
    public var initial_conversation: Identifier<Conversation>?
    public var confirm: Confirmation?
    public var response_url_enabled: Bool?
    public var filter: ConversationFilter?
}
