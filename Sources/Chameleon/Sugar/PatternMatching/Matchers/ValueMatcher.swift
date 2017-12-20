
/// Matches when the prefix of the input equals
/// one of the provided `String` representation of the value
struct ValueMatcher: Matcher {
    let value: Any
    let matches: [String]

    init(value: Any, matches: [String]) {
        self.value = value
        self.matches = matches.map { $0.lowercased() }
    }

    func match(against input: String) -> Match? {
        let sanitizedInput = input.lowercased()

        guard let match = matches.first(where: sanitizedInput.hasPrefix)
            else { return nil }

        return Match(
            key: nil,
            value: value,
            matched: String(input[input.startIndex..<match.endIndex])
        )
    }

    var matcherDescription: String {
        return String(describing: value)
    }
}
