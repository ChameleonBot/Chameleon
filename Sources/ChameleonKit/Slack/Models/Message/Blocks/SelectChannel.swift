public struct SelectChannel: Codable, Equatable {
    public static let type = "channels_select"

    public var type: String
    public var placeholder: Text.PlainText
    public var action_id: String
    public var initial_channel: Identifier<Channel>?
    public var confirm: Confirmation?
    public var response_url_enabled: Bool?
}
