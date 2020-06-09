import ChameleonKit
import Foundation

extension FixtureSource {
    public static func text(_ text: String) throws -> FixtureSource<RichTextElement> {
        return .init(raw: """
        {
            "type": "text",
            "text": "\(text)"
        }
        """)
    }
}
