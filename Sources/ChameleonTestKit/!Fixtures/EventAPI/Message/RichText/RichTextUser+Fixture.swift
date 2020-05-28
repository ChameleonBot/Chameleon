import ChameleonKit
import Foundation

extension FixtureSource {
    public static func user(_ id: String) throws -> FixtureSource<SlackReceiver, Message.Layout.RichText.Element.User> {
        return try .init(json: "RichTextUser", map: [.userId: id])
    }
}
