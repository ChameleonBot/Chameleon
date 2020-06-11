import ChameleonKit
import Foundation

extension FixtureSource {
    public static func teamJoin(user: FixtureSource<User>) throws -> FixtureSource<SlackDispatcher> {
        return try .init(jsonFile: "TeamJoin", map: [.user: user.string()])
    }
}
