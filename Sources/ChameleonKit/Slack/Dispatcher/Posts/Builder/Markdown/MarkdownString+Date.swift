import Foundation

public struct DateFormatString {
    let value: String
}

extension DateFormatString: ExpressibleByStringInterpolation {
    public struct StringInterpolation: StringInterpolationProtocol {
        var blocks: [String] = []

        public init(literalCapacity: Int, interpolationCount: Int) { }

        public mutating func appendLiteral(_ literal: String) {
            blocks.append(literal.slackEscaped())
        }
        public mutating func appendInterpolation(_ value: DateFormatString.Token) {
            blocks.append(value.token)
        }
    }

    public init(stringLiteral value: String) {
        self = .init(value: value.slackEscaped())
    }
    public init(stringInterpolation: StringInterpolation) {
        self = .init(value: stringInterpolation.blocks.joined())
    }
}

extension DateFormatString {
    public struct Token {
        let token: String

        public static let dateNum = Token(token: "{date_num}")
        public static let date = Token(token: "{date}")
        public static let dateShort = Token(token: "{date_short}")
        public static let dateLong = Token(token: "{date_long}")
        public static let datePretty = Token(token: "{date_pretty}")
        public static let dateShortPretty = Token(token: "{date_short_pretty}")
        public static let dateLongPretty = Token(token: "{date_long_pretty}")
        public static let time = Token(token: "{time}")
        public static let timeSeconds = Token(token: "{time_secs}")
    }
}

private let fallbackFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .full
    formatter.timeStyle = .full
    return formatter
}()

extension MarkdownString.StringInterpolation {
    public mutating func appendInterpolation(_ value: Date, format: DateFormatString, url: URL) {
        let result = "<!date^\(Int(value.timeIntervalSince1970))^\(format.value)^\(url.absoluteString)|\(fallbackFormatter.string(from: value))>"
        blocks.append(result)
    }
    public mutating func appendInterpolation(_ value: TimeInterval, format: DateFormatString, url: URL) {
        self.appendInterpolation(Date(timeIntervalSince1970: value), format: format, url: url)
    }

    public mutating func appendInterpolation(_ value: Date, format: DateFormatString) {
        let result = "<!date^\(Int(value.timeIntervalSince1970))^\(format.value)|\(fallbackFormatter.string(from: value))>"
        blocks.append(result)
    }
    public mutating func appendInterpolation(_ value: TimeInterval, format: DateFormatString) {
        self.appendInterpolation(Date(timeIntervalSince1970: value), format: format)
    }
}
