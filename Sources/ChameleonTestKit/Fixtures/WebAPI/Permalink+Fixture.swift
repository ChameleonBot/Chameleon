import ChameleonKit
import Foundation

extension FixtureSource {
    public static func permalink(channelId: String, url: URL) -> FixtureSource<SlackDispatcher> {
        return .init(raw: """
        {
            "ok": true,
            "channel": "\(channelId)",
            "permalink": "\(url.absoluteString)"
        }
        """)
    }
}
