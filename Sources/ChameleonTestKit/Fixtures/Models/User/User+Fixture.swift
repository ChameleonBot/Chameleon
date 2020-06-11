import ChameleonKit
import Foundation

extension FixtureSource {
    public static func bot() throws -> FixtureSource<User> {
        return try .init(jsonFile: "Bot")
    }

    public static func user(email: String? = nil) throws -> FixtureSource<User> {
        return try .init(jsonFile: "User", map: [.email: email ?? "null"])
    }
}
