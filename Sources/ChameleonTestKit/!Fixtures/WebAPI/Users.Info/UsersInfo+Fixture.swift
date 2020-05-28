import ChameleonKit
import Foundation

extension FixtureSource {
    public static func bot() throws -> FixtureSource<SlackDispatcher, User> {
        return try .init(json: "UsersInfo_Bot")
    }
}
