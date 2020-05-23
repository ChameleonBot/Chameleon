extension Message.Layout.RichText {
    public struct Preformatted: Codable, Equatable {
        public static let type = "rich_text_preformatted"

        public var type: String
        @ManyOf<RichTextElements> public var elements: [RichTextElement]
    }
}
