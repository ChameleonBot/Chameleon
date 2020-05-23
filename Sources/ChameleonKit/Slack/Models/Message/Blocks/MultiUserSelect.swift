public struct MultiUserSelect: Codable, Equatable {
    public static let type = "multi_users_select"

    public var type: String
    public var placeholder: Text.PlainText
    public var action_id: String
    @Default<Empty> public var initial_users: [Identifier<User>]
    public var confirm: Confirmation?
    public var max_selected_items: Int?
}
