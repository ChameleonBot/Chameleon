import Foundation

public struct SlashCommand: Codable, Equatable {
    public var command: SlackSlashCommand
    public var text: String
    public var response_url: URL
    public var trigger_id: String
    public var user_id: Identifier<User>
    public var team_id: Identifier<Team>
    public var channel_id: Identifier<ChameleonKit.Channel>
}

