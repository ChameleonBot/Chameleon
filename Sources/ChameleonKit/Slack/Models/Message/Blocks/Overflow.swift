public struct Overflow: Codable, Equatable {
    public static let type = "overflow"

    public var type: String
    public var action_id: String
    public var options: [Option]
    public var confirm: Confirmation?
}
