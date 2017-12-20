
public extension Matcher {
    /// Make this `Matcher` optional
    var orNone: Matcher {
        return OptionalMatcher(matcher: self)
    }
}

struct OptionalMatcher: Matcher {
    let matcher: Matcher

    func match(against input: String) -> Match? {
        let match = matcher.match(against: input)

        return match ?? Match(
            key: nil,
            value: "",
            matched: ""
        )
    }

    var greedy: Bool { return matcher.greedy }
    var matcherDescription: String {
        let sanitized = matcher
            .matcherDescription
            .replacingOccurrences(of: "\n", with: "")

        return sanitized.isEmpty
            ? ""
            : "[\(sanitized.strippingSyntax())]"
    }
}
