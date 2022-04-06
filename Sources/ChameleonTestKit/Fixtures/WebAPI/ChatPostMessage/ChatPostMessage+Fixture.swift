import ChameleonKit
import Foundation

extension FixtureSource {
    public static func emptyMessage() throws -> FixtureSource<SlackDispatcher> {
        return try .init(jsonFile: "ChatPostMessage_Empty")
    }
}
