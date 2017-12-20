
extension Sequence where Iterator.Element: Matcher {
    /// Match any of the `Matcher`s within this `Sequence`
    public var any: Matcher {
        return SequenceMatcher(matchers: Array(self))
    }
}

/// Attempts to match the input against each `Matcher` returning the first `Match` found, if any
struct SequenceMatcher: Matcher {
    private let matchers: [Matcher]

    init(matchers: [Matcher]) {
        self.matchers = Array(matchers)
    }
    func match(against input: String) -> Match? {
        return matchers
            .lazy
            .flatMap { $0.match(against: input) }
            .first
    }

    var matcherDescription: String {
        let description = matchers
            .map { $0.matcherDescription }
            .joined(separator: "|")

        return "(\(description))"
    }
}
