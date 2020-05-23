extension Message.Layout.RichText.Element {
    public struct Emoji: Codable, Equatable {
        public static let type = "emoji"

        public var type: String
        public var name: ChameleonKit.Emoji
    }
}
