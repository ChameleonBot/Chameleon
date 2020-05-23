extension Message.Layout {
    public struct Actions: Codable, Equatable {
        public static let type = "actions"

        public var type: String
        @ManyOf<BlockElements> public var elements: [BlockElement]
        public var block_id: String?
    }
}
