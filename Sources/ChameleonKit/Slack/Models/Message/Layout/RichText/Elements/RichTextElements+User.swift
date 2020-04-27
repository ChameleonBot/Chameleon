extension Message.Layout.RichText.Element {
    public struct User: Codable, Equatable {
        public static let type = "user"

        public var type: String
        public var user_id: Identifier<ChameleonKit.User>
    }
}
