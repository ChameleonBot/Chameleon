public struct NoValue {
    public init() { }
}

public struct ElementMatcher {
    public enum Error: Swift.Error {
        case typeMismatch(expected: Any.Type, value: Any?)
    }

    public typealias Match = (values: [Any], remaining: AnyCollection<RichTextElement>)

    public let match: (AnyCollection<RichTextElement>) -> Match?

    public init(match: @escaping (AnyCollection<RichTextElement>) -> Match?) {
        self.match = match
    }

    public static func ||(lhs: ElementMatcher, rhs: ElementMatcher) -> ElementMatcher {
        return .init { lhs.match($0) ?? rhs.match($0) }
    }
    public static func &&(lhs: ElementMatcher, rhs: ElementMatcher) -> ElementMatcher {
        return .init { elements in
            switch lhs.match(elements) {
            case let lhsMatch?:
                switch rhs.match(lhsMatch.remaining) {
                case let rhsMatch?:
                    return (lhsMatch.values + rhsMatch.values, rhsMatch.remaining)

                case nil:
                    return nil
                }

            case nil:
                return nil
            }
        }
    }
}

extension ElementMatcher {
    public static var always: ElementMatcher {
        return .init { ([NoValue()], $0) }
    }
}
