import ChameleonKit
import ChameleonTestKit

extension FixtureSource {
    static func message(_ value: String) -> FixtureSource<SlackReceiver, Message> {
        return .init(raw: """
        {
          "ts" : "1591498892.001400",
          "event_ts" : "1591498892.001400",
          "type" : "message",
          "channel_type" : "im",
          "text" : "\(value)",
          "user" : "U0000000001",
          "channel" : "D0000000000",
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
