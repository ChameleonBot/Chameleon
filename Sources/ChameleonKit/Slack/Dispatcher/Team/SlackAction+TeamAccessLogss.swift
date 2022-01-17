import Foundation

public struct AccessLogs: Equatable, Codable {
    public struct Paging: Equatable, Codable {
        public var count: Int
        public var total: Int
        public var page: Int
        public var pages: Int
    }

    public var logins: [Login]
    public var paging: Paging
}

public struct Login: Equatable, Codable {
    public var user_id: Identifier<User>
    public var username: String
    public var date_first: String
    public var date_last: String
    public var count: Int
    public var ip: String
    public var user_agent: String
    public var country: String
    public var region: String
}

extension SlackAction {
    public static func teamAccessLogs(before: TimeInterval? = nil, count: Int = 100) -> SlackAction<AccessLogs> {
        return .init(name: "team.accessLogs", method: .get)
    }
}
