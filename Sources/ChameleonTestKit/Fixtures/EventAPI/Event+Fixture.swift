import ChameleonKit

extension FixtureSource where Context == SlackReceiver {
    public static func event<T>(token: String = SlackBot.validTestToken, _ fixture: FixtureSource<T>) throws -> FixtureSource {
        let inner = try String(data: fixture.data(), encoding: .utf8)!
        return try FixtureSource(jsonFile: "Event", map: [
            .token: token,
            .event: inner
        ])
    }
}
