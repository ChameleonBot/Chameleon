import ChameleonKit
import Foundation

extension FixtureSource {
	public static func emoji(_ emoji: Emoji) -> FixtureSource<RichTextElement> {
		return .init(raw: """
		{
			"type": "emoji",
			"name": "\(emoji.rawValue)"
		}
		""")
	}
}
