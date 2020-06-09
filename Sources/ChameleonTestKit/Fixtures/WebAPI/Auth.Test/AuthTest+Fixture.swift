import ChameleonKit
import Foundation

extension FixtureSource {
    public static func authDetails() throws -> FixtureSource<SlackDispatcher> {
        return try .init(jsonFile: "AuthTest")
    }
}
