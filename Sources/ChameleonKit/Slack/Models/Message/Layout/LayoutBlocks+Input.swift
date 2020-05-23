extension Message.Layout {
    public struct Input: Codable, Equatable {
        public static let type = "input"

        public var type: String
        public var label: Text.PlainText
        @AnyOf<BlockElements> public var element: BlockElement // An plain-text input element, a select menu element, a multi-select menu element, or a datepicker.
        public var block_id: String?
        public var hint: Text.PlainText?
        @Default<False> public var optional: Bool
    }
}
