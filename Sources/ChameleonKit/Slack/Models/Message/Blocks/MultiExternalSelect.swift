public struct MultiExternalSelect: Codable, Equatable {
    public static let type = "multi_external_select"

    public var type: String
    public var placeholder: Text.PlainText
    public var action_id: String
    public var min_query_length: Int?
    @Default<Empty> public var initial_options: [Option]
    public var confirm: Confirmation?
    public var max_selected_items: Int?
}
