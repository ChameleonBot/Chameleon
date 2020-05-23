import ChameleonKit
import Foundation

extension FixtureSource where T == Message.Layout.RichText.Element.User {
    static func user(_ id: String) throws -> FixtureSource {
        return try .init(json: "RichTextUser", map: [.userId: id])
    }
}
