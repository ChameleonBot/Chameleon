import ChameleonKit
import Foundation

extension FixtureSource {
    public static func user(_ id: String) throws -> FixtureSource<RichTextElement> {
        return .init(raw: """
        {
            "type": "user",
            "user_id": "\(id)"
        }
        """)
    }
}
