extension Message {
    public struct Subtype: Codable, Equatable, RawRepresentable {
        public static var message_changed: Subtype { return .init(rawValue: #function) }
        public static var thread_broadcast: Subtype { return .init(rawValue: #function) }

        public var rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}
