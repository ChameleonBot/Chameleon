public struct CheckboxGroup: Codable, Equatable {
    public static let type = "checkboxes"

    public var type: String
    public var action_id: String
    public var options: [Option]
    public var initial_options: [Option]
    public var confirm: Confirmation?
}
