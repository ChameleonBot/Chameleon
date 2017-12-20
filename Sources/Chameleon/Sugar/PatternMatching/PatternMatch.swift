
extension PatternMatch {
    enum Error: Swift.Error {
        case missingKey(key: String)
        case typeMismatch(key: String, expected: Any.Type, found: Any.Type)
    }
}

/// Represents the results of matching a series of `Matcher`s against provided `String`
public struct PatternMatch {
    private let matches: [Match]

    init(matches: [Match]) {
        self.matches = matches
    }

    /// Attempt to extract the underlying matched value for the provided `key`
    public func value<T>(key: String) throws -> T {
        guard let match = matches.first(where: { $0.key == key })
            else { throw Error.missingKey(key: key) }

        guard let value = match.value as? T
            else { throw Error.typeMismatch(key: key, expected: T.self, found: type(of: match.value)) }

        return value
    }
}

/// Provides a `String` that represents the specification for an entire pattern
public func patternDescription(_ pattern: [Matcher]) -> String {
    return pattern
        .map { $0.matcherDescription }
        .filter { !$0.isEmpty }
        .joined(separator: " ")
}
