import Foundation

extension Interaction.Button: Action { }

extension Interaction {
    public struct Button: Codable, Equatable {
        public static let type = "button"

        public var type: String
        public var action_id: String
        public var block_id: String
        @Convertible<StringTimestamp> public var action_ts: Date

        public var text: Text.PlainText
        public var value: String?
    }
}
