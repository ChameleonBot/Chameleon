
struct DynamicMatcher: Matcher {
    typealias MatchTest = (String) -> Match?

    let greedy: Bool
    let match: MatchTest

    init(greedy: Bool, match: @escaping MatchTest) {
        self.greedy = greedy
        self.match = match
    }

    func match(against input: String) -> Match? {
        return match(input)
    }
    var matcherDescription: String { return "" }
}
