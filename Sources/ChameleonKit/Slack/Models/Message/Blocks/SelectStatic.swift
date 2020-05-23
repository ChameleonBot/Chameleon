public struct SelectStatic: Codable, Equatable {
    public static let type = "static_select"

    public var type: String
    public var placeholder: Text.PlainText
    public var action_id: String

    public var options: [Option] //?               // \___ should only use 1 of these 2
    //    public var option_groups: [OptionGroup]?    // /
    @Default<Empty> public var initial_options: [Option]

    public var confirm: Confirmation?
}
