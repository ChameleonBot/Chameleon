import Foundation

public struct Interaction: Codable, Equatable {
    private enum CodingKeys: String, NestedCodingKey {
        case type, trigger_id, response_url, actions
        case team = "team.id"
        case channel = "channel.id"
        case user = "user.id"
        case message_ts = "container.message_ts"
        case view_id = "container.view_id"
    }
    public var type: String

    public var trigger_id: String
    public var response_url: URL

    @NestedKey public var message_ts: String?
    @NestedKey public var view_id: String?

    @NestedKey public var team: Identifier<Team>
    @NestedKey public var channel: Identifier<ChameleonKit.Channel>
    @NestedKey public var user: Identifier<User>

    //message or view (or null eventually?)

    @ManyOf<Actions> public var actions: [Action]
}
