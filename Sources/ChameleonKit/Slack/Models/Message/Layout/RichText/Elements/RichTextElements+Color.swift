extension Message.Layout.RichText.Element {
    public struct Color: Codable, Equatable {
        public static let type = "color"

        public var type: String
        public var value: ChameleonKit.Color
    }
}
