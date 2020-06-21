import ChameleonKit
import Foundation

extension FixtureSource {
    public static func link(text: String? = nil, url: URL) throws -> FixtureSource<RichTextElement> {
        return .init(raw: """
        {
            "type": "link",
            "text": "\(text ?? "null")",
            "url": "\(url.absoluteString)"
        }
        """)
    }
}
