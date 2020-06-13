import Foundation

extension Text: ExpressibleByStringInterpolation {
    public typealias StringInterpolation = MarkdownString.StringInterpolation

    public init(stringLiteral value: String) {
        self = .markdown(.init(type: Markdown.type, text: value.slackEscaped(), verbatim: false))
    }
    public init(stringInterpolation: MarkdownString.StringInterpolation) {
        self = .markdown(.init(type: Markdown.type, text: stringInterpolation.blocks.joined(), verbatim: false))
    }
}

extension Text.Markdown: ExpressibleByStringInterpolation {
    public typealias StringInterpolation = MarkdownString.StringInterpolation

    public init(stringLiteral value: String) {
        self = .init(type: Text.Markdown.type, text: value.slackEscaped(), verbatim: false)
    }
    public init(stringInterpolation: MarkdownString.StringInterpolation) {
        self = .init(type: Text.Markdown.type, text: stringInterpolation.blocks.joined(), verbatim: false)
    }
}

extension Text.PlainText: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .init(type: Text.PlainText.type, text: value.slackEscaped(), emoji: false)
    }
}

extension String {
    func slackEscaped() -> String {
        return self
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
    }
}
