import ChameleonKit
import Foundation

extension FixtureSource {
    public static func emptyMessage() throws -> FixtureSource<SlackDispatcher, Message> {
        return try .init(jsonFile: "ChatPostMessage_Any")
    }
}
