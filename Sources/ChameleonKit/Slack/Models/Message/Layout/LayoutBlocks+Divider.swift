extension Message.Layout {
    public struct Divider: Codable, Equatable {
        public static let type = "divider"

        public var type: String
        public var block_id: String?
    }
}
