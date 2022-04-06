import ChameleonKit
import Foundation

extension FixtureSource {
    public static func teamJoin(_ user: FixtureSource<User>) throws -> FixtureSource<SlackReceiver> {
        return try .init(jsonFile: "TeamJoin", map: [.user: user.string()])
    }
}
