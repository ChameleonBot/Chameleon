extension Parser {
    public static var start: Parser<Void> {
        return .init { input in
            guard input.startIndex == input.base.startIndex else {
                throw ParserError.matchFailed(name: "start", reason: "Not at the start, prefix: '\(input.base[...input.startIndex])'")
            }
            return (value: (), remainder: input)
        }
    }
    public static var end: Parser<Void> {
        return .init { input in
            guard input.isEmpty else { throw ParserError.matchFailed(name: "end", reason: "End not reached, remainder: '\(input)'") }
            return ((), input)
        }
    }
}
