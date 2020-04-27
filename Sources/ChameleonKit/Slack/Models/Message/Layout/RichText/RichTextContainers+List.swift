extension Message.Layout.RichText {
    public struct List: Codable, Equatable {
        public enum Style: String, Codable, Equatable {
            case ordered, bullet
        }

        public static let type = "rich_text_list"

        public var type: String
        public var style: Style
        public var elements: [Message.Layout.RichText.Section]
    }
}
