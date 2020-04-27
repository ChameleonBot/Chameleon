extension ElementMatcher: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = .equals(value)
    }
}
//extension ElementMatcher: ExpressibleByStringInterpolation {
//    public struct StringInterpolation: StringInterpolationProtocol {
//        public var parsers: [Parser<[Any]>] = []
//
//        var matcher: ElementMatcher {
//            let initial = Parser.just(NoValue()).map { [$0] as [Any] }
//
//            let parser = parsers.reduce(initial) { acc, parser in
//                return acc.flatMap { values in
//                    return parser.map { values + $0 }
//                }
//            }
//
//            return .init { elements in
//                guard
//                    let element = elements.first as? Message.Layout.RichText.Element.Text,
//                    let match = parser.parse(element.text[...])
//                    else { return nil }
//
//                return (match.value, elements.dropFirst())
//            }
//        }
//
//        public init(literalCapacity: Int, interpolationCount: Int) { }
//
//        public mutating func appendLiteral(_ literal: String) {
//            guard !literal.isEmpty else { return }
//
//            parsers.append(Parser.literal(literal).map { _ in [NoValue()] })
//        }
//
//        public mutating func appendInterpolation<T>(_ parser: Parser<T>) {
//            parsers.append(parser.map({ [$0] }))
//        }
//    }
//
//    public init(stringLiteral value: String) {
//        self = .equals(value)
//    }
//    public init(stringInterpolation: StringInterpolation) {
//        self = stringInterpolation.matcher
//    }
//}

extension ElementMatcher {
    public static func equals(_ value: String) -> ElementMatcher {
        return .init { elements in
            guard let element = elements.first as? Message.Layout.RichText.Element.Text else { return nil }
            return element.text.lowercased() == value.lowercased() ? ([NoValue()], elements.dropFirst()) : nil
        }
    }

    public static func contains(_ value: String) -> ElementMatcher {
        return .init { elements in
            guard let element = elements.first as? Message.Layout.RichText.Element.Text else { return nil }
            return element.text.lowercased().contains(value.lowercased()) ? ([NoValue()], elements.dropFirst()) : nil
        }
    }

    public static func startsWith(_ value: String) -> ElementMatcher {
        return .init { elements in
            guard let element = elements.first as? Message.Layout.RichText.Element.Text else { return nil }
            return element.text.lowercased().starts(with: value.lowercased()) ? ([NoValue()], elements.dropFirst()) : nil
        }
    }

    public static func endsWith(_ value: String) -> ElementMatcher {
        return .init { elements in
            guard let element = elements.first as? Message.Layout.RichText.Element.Text else { return nil }
            return element.text.lowercased().starts(with: value.lowercased()) ? ([NoValue()], elements.dropFirst()) : nil
        }
    }
}
