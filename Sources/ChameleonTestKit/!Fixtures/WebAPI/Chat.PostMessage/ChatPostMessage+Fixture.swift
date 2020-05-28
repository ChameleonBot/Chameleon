import ChameleonKit
import Foundation

extension FixtureSource {
    public static func emptyMessage() throws -> FixtureSource<SlackDispatcher, Message> {
        return try .init(json: "ChatPostMessage_Any")
    }
}
