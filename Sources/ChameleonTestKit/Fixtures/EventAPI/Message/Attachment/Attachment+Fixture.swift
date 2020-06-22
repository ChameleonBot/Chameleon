import ChameleonKit
import Foundation

extension FixtureSource {
    public static func attachment(
        id: String = "1",
        fallback: String? = nil,
        text: String? = nil,
        title: String? = nil,
        title_link: URL? = nil,
        original_url: URL? = nil
    ) -> FixtureSource<Message.Attachment> {
        return .init(raw: """
        {
          "id" : \(id),
          "title" : "\(title ?? "null")",
          "text" : "\(text ?? "null")",
          "original_url" : "\(original_url?.absoluteString ?? "null")",
          "title_link" : "\(title_link?.absoluteString ?? "null")",
          "fallback" : "\(fallback ?? "null")"
        }
        """)
    }
}
