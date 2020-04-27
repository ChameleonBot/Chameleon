import Foundation

public struct AuthenticationDetails: Codable, Equatable {
    public var url: URL
    public var team: String
    public var user: String
    public var team_id: Identifier<Team>
    public var user_id: Identifier<User>
}
