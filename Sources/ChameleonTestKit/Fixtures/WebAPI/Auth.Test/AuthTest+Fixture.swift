import ChameleonKit
import Foundation

extension FixtureSource {
    public static func authDetails() throws -> FixtureSource<SlackDispatcher, AuthenticationDetails> {
        return try .init(jsonFile: "AuthTest")
    }
}
