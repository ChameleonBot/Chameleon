import ChameleonKit

extension FixtureSource where Context == SlackReceiver {
    public static func event(token: String = SlackBot.validTestToken, _ fixture: FixtureSource) throws -> FixtureSource {
        let inner = try String(data: fixture.data(), encoding: .utf8)!
        return try FixtureSource(jsonFile: "Event", map: [
            .token: token,
            .event: inner
        ])
    }
}
