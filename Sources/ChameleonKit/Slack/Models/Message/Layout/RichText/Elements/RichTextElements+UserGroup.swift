extension Message.Layout.RichText.Element {
    public struct UserGroup: Codable, Equatable {
        public static let type = "usergroup"

        public var type: String
        public var usergroup_id: Identifier<ChameleonKit.UserGroup>
    }
}
