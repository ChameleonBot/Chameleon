import ChameleonKit
import Foundation

extension FixtureSource {
    public static func usersInfo(_ user: FixtureSource<User>) throws -> FixtureSource<SlackDispatcher> {
        return try .init(jsonFile: "UsersInfo", map: [.user: user.string()])
    }
}
