extension Message.Layout.RichText.Element {
    public struct Text: Codable, Equatable {
        public struct Style: Codable, Equatable {
            @Default<False> public var code: Bool
            @Default<False> public var bold: Bool
            @Default<False> public var italic: Bool
            @Default<False> public var strike: Bool
        }

        public static let type = "text"

        public var type: String
        public var text: String
        @Default<Null> public var style: Style
    }
}
