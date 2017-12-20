
import Foundation

/// Matches as much of the input as possible with the first `Matcher`
/// until the second `Matcher` matches.
///
/// NOTE: If the second `Matcher` does not match but the first can
/// consume the entire input it will and that will be the returned `Match`
struct GreedyMatcher: Matcher {
    private let first: Matcher
    private let second: Matcher

    init(match first: Matcher, until second: Matcher) {
        self.first = first
        self.second = second
    }
    func match(against input: String) -> Match? {
        guard first.greedy else { return first.match(against: input) }

        let indices = input.indices + [input.endIndex]
        for index in indices {
            let pair = input.split(at: index)

            guard second.match(against: pair.after) != nil else { continue }

            return first.match(against: pair.before)
        }

        return first.match(against: input)
    }

    var greedy: Bool { return first.greedy }
    var matcherDescription: String { return first.matcherDescription }
}

extension Matcher {
    func until(other: Matcher?) -> Matcher {
        guard let other = other else { return self }

        return GreedyMatcher(match: self, until: other)
    }
}
