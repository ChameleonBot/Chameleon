import ChameleonKit
import Foundation

extension FixtureSource {
    public static func bot() throws -> FixtureSource<SlackDispatcher> {
        return try .init(jsonFile: "UsersInfo_Bot")
    }

    public static func user(email: String? = nil) throws -> FixtureSource<SlackDispatcher> {
        return try .init(jsonFile: "UsersInfo_User", map: [.email: email ?? "null"])
    }
}
