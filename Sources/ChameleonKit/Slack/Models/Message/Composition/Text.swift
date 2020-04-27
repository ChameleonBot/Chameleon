public enum Text: Codable, Equatable {
    case plainText(PlainText)
    case markdown(Markdown)

    public init(from decoder: Decoder) throws {
        self = try decoder.decodeFirst(from: [
            .case(Self.plainText, when: "type", equals: PlainText.type),
            .case(Self.markdown, when: "type", equals: Markdown.type),
        ])
    }
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .plainText(let value): try value.encode(to: encoder)
        case .markdown(let value): try value.encode(to: encoder)
        }
    }
}

extension Text {
    public struct PlainText: Codable, Equatable {
        public static let type = "plain_text"

        public var type: String
        public var text: String
        @Default<False> public var emoji: Bool
    }
    public struct Markdown: Codable, Equatable {
        public static let type = "mrkdwn"

        public var type: String
        public var text: String
        @Default<False> public var verbatim: Bool
    }
}
