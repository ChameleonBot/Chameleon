public struct NoValue {
    public init() { }
}

public struct ElementMatcher {
    public typealias Match = (values: [Any], remaining: ArraySlice<RichTextElement>)

    public let match: (ArraySlice<RichTextElement>) throws -> Match

    public init(match: @escaping (ArraySlice<RichTextElement>) throws -> Match) {
        self.match = match
    }

    public static func ||(lhs: ElementMatcher, rhs: ElementMatcher) -> ElementMatcher {
        return .init { elements in
            do {
                return try lhs.match(elements)
            } catch let lhsError as ElementMatcher.Error {
                do {
                    return try rhs.match(elements)
                } catch let rhsError as ElementMatcher.Error {
                    throw Error.allFailed(name: "||", errors: [lhsError, rhsError])
                }
            }
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

extension ElementMatcher {
    public enum Error: Swift.Error, CustomStringConvertible {
        case incorrectElement(expected: Any.Type, received: Any.Type?)
        case matchFailed(name: String, reason: String)
        case typeMismatch(expected: Any.Type, value: Any?)
        case allFailed(name: String, errors: [ElementMatcher.Error])

        public var description: String {
            switch self {
            case .incorrectElement(let expected, let received):
                return "Expected element type \(expected), instead received \(received as Any)"
            case .matchFailed(let name, let reason):
                return "\(name) failed: \(reason)"
            case .typeMismatch(let expected, let value):
                return "Expected value type \(expected), received value \(value as Any)"
            case .allFailed(let name, let errors):
                let errorString = errors
                    .flatMap { $0.inner() }
                    .map { "\t-\($0)" }
                    .joined(separator: "\n")
                return "All provided matchers in \(name) failed\n\(errorString)"
            }
        }
    }
}

private extension ElementMatcher.Error {
    func inner() -> [Error] {
        switch self {
        case .allFailed(_, let errors):
            return errors.flatMap { $0.inner() }
        default:
            return [self]
        }
    }
}
