extension Message.Layout.RichText.Element {
    public struct Broadcast: Codable, Equatable {
        public static let type = "broadcast"

        public var type: String
        public var range: ChameleonKit.Broadcast
    }
}

