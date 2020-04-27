extension Message.Layout.RichText {
    public struct Quote: Codable, Equatable {
        public static let type = "rich_text_quote"

        public var type: String
        @ManyOf<RichTextElements> public var elements: [RichTextElement]
    }
}
