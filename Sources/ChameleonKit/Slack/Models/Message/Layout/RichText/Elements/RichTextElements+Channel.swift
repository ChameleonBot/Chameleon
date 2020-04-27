extension Message.Layout.RichText.Element {
    public struct Channel: Codable, Equatable {
        public static let type = "channel"

        public var type: String
        public var channel_id: Identifier<ChameleonKit.Channel>
    }
}
