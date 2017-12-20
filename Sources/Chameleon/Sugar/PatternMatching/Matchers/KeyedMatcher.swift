
/// Wraps an existing `Matcher` and adds the provided key to any `Match` found
struct KeyedMatcher: Matcher {
    private let matcher: Matcher
    private let key: String

    init(matcher: Matcher, key: String) {
        self.matcher = matcher
        self.key = key
    }

    func match(against input: String) -> Match? {
        return matcher.match(against: input)?.with(key: key)
    }

    var greedy: Bool { return matcher.greedy }
    var matcherDescription: String { return "<\(key)>" }
}

public extension Matcher {
    /// Create a new `Matcher` from the reciever which associate a key with any `Match`es it produces
    func using(key: String) -> Matcher {
        return KeyedMatcher(matcher: self, key: key)
    }
}
