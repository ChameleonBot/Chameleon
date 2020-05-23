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
    public struct Modifier {
        let modify: (String) -> String

        public init(modify: @escaping (String) -> String) {
            self.modify = modify
        }

        public static let none = Modifier { $0 }
        public static let bold = Modifier { "*\($0)*" }
        public static let italic = Modifier { "_\($0)_" }
        public static let strike = Modifier { "~\($0)~" }
        public static let inlineCode = Modifier { "`\($0)`" }
        public static let code = Modifier { "```\($0)```" }
    }

    //https://api.slack.com/reference/surfaces/formatting#block-formatting
    public struct StringInterpolation: StringInterpolationProtocol {
        var blocks: [String] = []

        public init(literalCapacity: Int, interpolationCount: Int) { }

        public mutating func appendLiteral(_ literal: String) {
            blocks.append(literal.slackEscaped())
        }
        public mutating func appendLiteral(_ literal: String, _ modifier: Modifier = .none) {
            blocks.append(modifier.modify(literal.slackEscaped()))
        }
        public mutating func appendInterpolation(_ emoji: Emoji) {
            blocks.append(":\(emoji.rawValue):")
        }
        
        public enum Quote { case quote }
        public mutating func appendInterpolation(_ value: String, _: Quote) {
            blocks.append(">\(value.slackEscaped())")
        }
        public mutating func appendInterpolation(_ lines: [String], _: Quote) {
            var lines = lines.map { "\n>\($0.slackEscaped())" }
            if lines.isEmpty, let first = lines.first {
                lines[0] = String(first[first.index(first.startIndex, offsetBy: 1)...])
            } else {
                blocks.append(contentsOf: lines)
            }
        }

        public mutating func appendInterpolation(_ value: URL, _ modifier: Modifier = .none) {
            blocks.append(modifier.modify("<\(value.absoluteString)>"))
        }
        public mutating func appendInterpolation(_ value: URL, _ title: MarkdownString) {
            blocks.append("<\(value.absoluteString)|\(title.value)>")
        }

        public mutating func appendInterpolation(_ value: Identifier<Channel>, _ modifier: Modifier = .none) {
            blocks.append(modifier.modify("<#\(value.rawValue)>"))
        }
        public mutating func appendInterpolation(_ value: Identifier<User>, _ modifier: Modifier = .none) {
            blocks.append(modifier.modify("<@\(value.rawValue)>"))
        }
        public mutating func appendInterpolation(_ value: Identifier<UserGroup>, _ modifier: Modifier = .none) {
            blocks.append(modifier.modify("<!subteam^\(value.rawValue)>"))
        }
        public mutating func appendInterpolation(_ value: Broadcast, _ modifier: Modifier = .none) {
            blocks.append(modifier.modify("<!\(value.rawValue)>"))
        }
        public mutating func appendInterpolation<T>(_ value: T, _ modifier: Modifier = .none) {
            blocks.append(modifier.modify("\(value)"))
        }
    }

    public init(stringLiteral value: String) {
        self = .init(value: value.slackEscaped())
    }
    public init(stringInterpolation: StringInterpolation) {
        self = .init(value: stringInterpolation.blocks.joined())
    }
}
