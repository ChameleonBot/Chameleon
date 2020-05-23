extension Message.Layout {
    public struct Section: Codable, Equatable {
        public static let type = "section"

        public var type: String
        public var text: Text
        public var block_id: String?
        public var fields: [Text]?
        @AnyOf<BlockElements?> public var accessory: BlockElement?
    }
}
