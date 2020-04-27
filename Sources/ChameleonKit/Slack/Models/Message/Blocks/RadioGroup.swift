public struct RadioGroup: Codable, Equatable {
    public static let type = "radio_buttons"

    public var type: String
    public var action_id: String
    public var options: [Option]
    public var initial_option: Option?
    public var confirm: Confirmation?
}
