extension Message.Layout {
    public struct Context: Codable, Equatable {
        public static let type = "context"

        public var type: String
        @ManyOf<BlockElements> public var elements: [BlockElement] // TODO: image elements and text objects.
        public var block_id: String?
    }
}
