
extension String {
    /// Tests the receiver incrementally against a sequence of `Matcher`s
    ///
    /// Testing is performed from left to right and each test must succeed in order otherwise the whole test fails.
    ///
    /// Examples
    /// You can perform simple pattern matching:
    /// ```
    /// let source = "hello @botname"
    /// if let helloCommand = source.patternMatch(against: [["hi", "hello", "hey"].any, slackBot.me]) {
    ///     // User said hello to the bot
    /// }
    /// ```
    ///
    /// or if you need to extract the values from the pattern:
    /// ```
    /// let source = "@botname give me a number between 0 and 42"
    /// if let command = source.patternMatch(against: [slackBot.me, "give me a number between", Int.any.using(key: "first"), "and", Int.any.using(key: "second")]) {
    ///     let first: Int = try command.value(key: "first")
    ///     let second: Int = command.value(key: "second")
    ///
    ///     //use Ints to get random number
    /// }
    /// ```
    ///
    /// - Parameter matchers: A sequence of `Matcher`s to attempt a match with
    /// - Parameter strict: When `false` the pattern is surrounded by `String.any.orNone` `Matcher`s to allow a more flexible input
    /// - Returns: A new `PatternMatch` instance if the receiver matches the `Matcher`s, otherwise `nil`
    public func patternMatch(against matchers: [Matcher], strict: Bool = true) -> PatternMatch? {
        var matchers = matchers
        if !strict {
            matchers.insert(String.any.orNone, at: 0)
            matchers.append(String.any.orNone)
        }

        var input = self
        var results: [Match] = []

        for (_, current, next) in matchers.neighbors {
            guard
                let match = current.until(other: next).match(against: input)
                else { return nil }

            results.append(match)
            input = input.remove(prefix: match.matched)
        }

        guard input.isEmpty else { return nil }
        
        return PatternMatch(matches: results)
    }

    public func patternMatches(against matchers: [Matcher], strict: Bool = true) -> Bool {
        return patternMatch(against: matchers, strict: strict) != nil
    }
}
