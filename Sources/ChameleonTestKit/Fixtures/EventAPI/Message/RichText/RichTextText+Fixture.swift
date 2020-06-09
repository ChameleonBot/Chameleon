import ChameleonKit
import Foundation

extension FixtureSource {
    public static func text(_ text: String) throws -> FixtureSource<SlackReceiver, Message.Layout.RichText.Element.Text> {
        return .init(raw: """
        {
            "type": "text",
            "text": "\(text)"
        }
        """)
    }
}
