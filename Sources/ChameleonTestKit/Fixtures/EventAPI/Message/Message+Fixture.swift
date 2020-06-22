import ChameleonKit
import Foundation

extension FixtureSource {
    private struct Elements: Encodable {
        @ManyOf<RichTextElements> public var elements: [RichTextElement]
    }
}

extension FixtureSource {
    public static func message(
        userId: String = "U0000000001",
        channelId: String = "C0000000000",
        kind: Channel.Kind = .channel,
        attachments: [FixtureSource<Message.Attachment>] = [],
        _ elements: [RichTextFixture]
    ) throws -> FixtureSource<Message> {

        let pairs = try elements
            .map { try $0.values() }
            .unzip()

        let text = pairs.0.joined().value
        let richTextElements = try String(data: JSONEncoder().encode(EncodeMany<RichTextElements>(values: pairs.1)), encoding: .utf8)!
        let attachmentsJson = try attachments
            .map { try String(data: $0.data(), encoding: .utf8)! }
            .joined(separator: ",")

        return .init(raw: """
        {
          "ts" : "1591498892.001400",
          "event_ts" : "1591498892.001400",
          "type" : "message",
          "channel_type" : "\(kind.rawValue)",
          "text" : "\(text)",
          "user" : "\(userId)",
          "channel" : "\(channelId)",
          "team" : "T00000000",
          "attachments": [\(attachmentsJson)],
          "blocks" : [
            {
              "elements" : [
                {
                  "elements" : \(richTextElements),
                  "type" : "rich_text_section"
                }
              ],
              "type" : "rich_text",
              "block_id" : "ORm"
            }
          ]
        }
        """)
    }
}

extension FixtureSource {
    public static func message(
        userId: String = "U0000000001",
        channelId: String = "C0000000000",
        kind: Channel.Kind = .channel,
        attachments: [FixtureSource<Message.Attachment>] = [],
        _ value: String
    ) throws -> FixtureSource<Message> {
        return try message(userId: userId, channelId: channelId, kind: kind, attachments: attachments, [.text(value)])
    }
}
