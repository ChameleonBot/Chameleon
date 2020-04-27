public struct SelectExternal: Codable, Equatable {
    public static let type = "external_select"

    public var type: String
    public var placeholder: Text.PlainText
    public var action_id: String
    public var initial_option: Option?
    public var min_query_length: Int?
    public var confirm: Confirmation?
}
