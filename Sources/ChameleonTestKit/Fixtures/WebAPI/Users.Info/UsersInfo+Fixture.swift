import ChameleonKit
import Foundation

extension FixtureSource {
    public static func bot() throws -> FixtureSource<SlackDispatcher> {
        return try .init(jsonFile: "UsersInfo_Bot")
    }
}
