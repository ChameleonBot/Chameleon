import ChameleonKit
import Foundation

extension FixtureSource {
    public static func bot() throws -> FixtureSource<User> {
        return try .init(jsonFile: "Bot")
    }

    public static func user(
        id: String = "U0000000001",
        name: String = "Test User",
        email: String? = nil
    ) throws -> FixtureSource<User> {

        return try .init(jsonFile: "User", map: [
            .email: email.map({ "\"\($0)\"" }) ?? "null",
            .userId: id,
            .name: name
        ])
    }
}
