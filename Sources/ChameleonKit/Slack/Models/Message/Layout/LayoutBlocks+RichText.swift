extension Message.Layout {
    public struct RichText: Codable, Equatable {
        public static let type = "rich_text"

        public var type: String
        public var block_id: String?
        @ManyOf<RichTextContainers> public var elements: [RichTextContainer]
    }
}
