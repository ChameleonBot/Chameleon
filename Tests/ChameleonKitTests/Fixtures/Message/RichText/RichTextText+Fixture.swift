import ChameleonKit
import Foundation

extension FixtureSource where T == Message.Layout.RichText.Element.Text {
    static func text(_ text: String) throws -> FixtureSource {
        return try .init(json: "RichTextText_NoStyle", map: [.text: text])
    }
}
