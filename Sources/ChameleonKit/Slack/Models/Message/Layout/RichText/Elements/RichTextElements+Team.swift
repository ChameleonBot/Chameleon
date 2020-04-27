extension Message.Layout.RichText.Element {
    public struct Team: Codable, Equatable {
        public static let type = "team"

        public var type: String
        public var team_id: Identifier<ChameleonKit.Team>
    }
}
