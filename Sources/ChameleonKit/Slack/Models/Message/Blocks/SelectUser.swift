public struct SelectUser: Codable, Equatable {
    public static let type = "users_select"

    public var type: String
    public var placeholder: Text.PlainText
    public var action_id: String
    public var initial_user: Identifier<User>?
    public var confirm: Confirmation?
}
