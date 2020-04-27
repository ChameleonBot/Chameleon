public struct NoValue {
    public init() { }
}

public struct ElementMatcher {
    public enum Error: Swift.Error {
        case incorrectElement(expected: Any.Type, received: Any.Type?)
        case matchFailed(name: String, reason: String)
        case typeMismatch(expected: Any.Type, value: Any?)
    }

    public typealias Match = (values: [Any], remaining: ArraySlice<RichTextElement>)

    public let match: (ArraySlice<RichTextElement>) throws -> Match

    public init(match: @escaping (ArraySlice<RichTextElement>) throws -> Match) {
        self.match = match
    }

    public static func ||(lhs: ElementMatcher, rhs: ElementMatcher) -> ElementMatcher {
        return .init { elements in
            do { return try lhs.match(elements) }
            catch { return try rhs.match(elements) }
        }
    }
    public static func &&(lhs: ElementMatcher, rhs: ElementMatcher) -> ElementMatcher {
        return .init { elements in
            let lhs = try lhs.match(elements)
            let rhs = try rhs.match(lhs.remaining)
            return (lhs.values + rhs.values, rhs.remaining)
        }
    }
}

extension ElementMatcher {
    public static var always: ElementMatcher {
        return .init { ([NoValue()], $0) }
    }
}
