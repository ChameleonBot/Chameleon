import ChameleonKit
import Foundation

extension FixtureSource {
    private struct Elements: Encodable {
        @ManyOf<RichTextElements> public var elements: [RichTextElement]
    }
}

extension FixtureSource {
    public static func message(
        userId: String = "U0000000000",
        channelId: String = "C0000000000",
        kind: Channel.Kind = .channel,
        _ elements: [RichTextElement]
    ) throws -> FixtureSource<SlackReceiver, Message> {

        let value = ""
        let richTextElements = try JSONEncoder().encode(EncodeMany<RichTextElements>(values: elements))

        return .init(raw: """
        {
          "ts" : "1591498892.001400",
          "event_ts" : "1591498892.001400",
          "type" : "message",
          "channel_type" : "\(kind.rawValue)",
          "text" : "\(value)",
          "user" : "\(userId)",
          "channel" : "\(channelId)",
          "team" : "T00000000",
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
        userId: String = "U0000000000",
        channelId: String = "C0000000000",
        kind: Channel.Kind = .channel,
        _ value: String
    ) -> FixtureSource<SlackReceiver, Message> {

        return .init(raw: """
        {
          "ts" : "1591498892.001400",
          "event_ts" : "1591498892.001400",
          "type" : "message",
          "channel_type" : "\(kind.rawValue)",
          "text" : "\(value)",
          "user" : "\(userId)",
          "channel" : "\(channelId)",
          "team" : "T00000000",
          "blocks" : [
            {
              "elements" : [
                {
                  "elements" : [
                    {
                      "type" : "text",
                      "text" : "\(value)"
                    }
                  ],
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
