extension Message.Layout.RichText {
    public struct Section: Codable, Equatable {
        public static let type = "rich_text_section"

        public var type: String
        @ManyOf<RichTextElements> public var elements: [RichTextElement]
    }
}
