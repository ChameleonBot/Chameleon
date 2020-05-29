import ChameleonKit
import Foundation

extension FixtureSource {
    public static func bot() throws -> FixtureSource<SlackDispatcher, User> {
        return try .init(jsonFile: "UsersInfo_Bot")
    }
}
