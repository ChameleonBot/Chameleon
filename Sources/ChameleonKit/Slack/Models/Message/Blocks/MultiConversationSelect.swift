public struct MultiConversationSelect: Codable, Equatable {
    public static let type = "multi_conversations_select"

    public var type: String
    public var placeholder: Text.PlainText
    public var action_id: String
    @Default<Empty> public var initial_conversations: [Identifier<Conversation>]
    public var confirm: Confirmation?
    public var max_selected_items: Int?
    public var filter: ConversationFilter?
}
