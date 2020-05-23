public struct TextInput: Codable, Equatable {
    public static let type = "plain_text_input"

    public var type: String
    public var action_id: String
    public var placeholder: Text.PlainText?
    public var initial_value: String?
    @Default<False> public var multiline: Bool
    public var min_length: Int?
    public var max_length: Int?
}
