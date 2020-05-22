import Foundation

public struct MarkdownString {
    let value: String

    public init(value: String) {
        self.value = value
    }

    public func appending(_ other: MarkdownString) -> MarkdownString {
        return .init(value: value + other.value)
    }
}
extension Array where Element == MarkdownString {
    public func joined(separator: String = "") -> MarkdownString {
        let string = self
            .map { $0.value }
            .joined(separator: separator)
        
        return .init(value: string)
    }
}

extension MarkdownString: ExpressibleByStringInterpolation {
    //https://api.slack.com/reference/surfaces/formatting#block-formatting
    public struct StringInterpolation: StringInterpolationProtocol {
        var blocks: [String] = []

        public init(literalCapacity: Int, interpolationCount: Int) { }

        public mutating func appendLiteral(_ literal: String) {
            blocks.append(literal.slackEscaped())
        }
        public mutating func appendInterpolation(_ emoji: Emoji) {
            blocks.append(":\(emoji.rawValue):")
        }

        public enum Bold { case bold }
        public mutating func appendInterpolation(_ value: String, _: Bold) {
            blocks.append("*\(value.slackEscaped())*")
        }

        public enum Italic { case italic }
        public mutating func appendInterpolation(_ value: String, _: Italic) {
            blocks.append("_\(value.slackEscaped())_")
        }

        public enum Strike { case strike }
        public mutating func appendInterpolation(_ value: String, _: Strike) {
            blocks.append("~\(value.slackEscaped())~")
        }

        public enum InlineCode { case inlineCode }
        public mutating func appendInterpolation(_ value: String, _: InlineCode) {
            blocks.append("`\(value.slackEscaped())`")
        }

        public enum Code { case code }
        public mutating func appendInterpolation(_ value: String, _: Code) {
            blocks.append("```\(value.slackEscaped())```")
        }

        public enum Quote { case quote }
        public mutating func appendInterpolation(_: Code, _ lines: [String]) {
            var lines = lines.map { "\n>\($0.slackEscaped())" }
            if lines.isEmpty, let first = lines.first {
                lines[0] = String(first[first.index(first.startIndex, offsetBy: 1)...])
            } else {
                blocks.append(contentsOf: lines)
            }
        }

        public mutating func appendInterpolation(_ value: URL) {
            blocks.append("<\(value.absoluteString)>")
        }
        public mutating func appendInterpolation(_ value: URL, _ title: MarkdownString) {
            blocks.append("<\(value.absoluteString)|\(title.value)>")
        }

        public mutating func appendInterpolation(_ value: Identifier<Channel>) {
            blocks.append("<#\(value.rawValue)>")
        }
        public mutating func appendInterpolation(_ value: Identifier<User>) {
            blocks.append("<@\(value.rawValue)>")
        }
        public mutating func appendInterpolation(_ value: Identifier<UserGroup>) {
            blocks.append("<!subteam^\(value.rawValue)>")
        }
        public mutating func appendInterpolation(_ value: Broadcast) {
            blocks.append("<!\(value.rawValue)>")
        }
        public mutating func appendInterpolation<T>(_ value: T) {
            blocks.append("\(value)")
        }
    }

    public init(stringLiteral value: String) {
        self = .init(value: value.slackEscaped())
    }
    public init(stringInterpolation: StringInterpolation) {
        self = .init(value: stringInterpolation.blocks.joined())
    }
}
