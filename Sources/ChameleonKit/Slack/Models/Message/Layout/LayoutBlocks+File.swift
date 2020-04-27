extension Message.Layout {
    public struct File: Codable, Equatable {
        public enum Source: String, Codable, Equatable {
            case remote
        }

        public static let type = "file"

        public var type: String
        public var external_id: String
        public var source: Source // always 'remote' right now
        public var block_id: String?
    }
}
