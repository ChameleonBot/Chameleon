extension Parser where T == Void {
    public static var end: Parser {
        return .init { input in
            guard input.isEmpty else { throw ParserError.matchFailed(name: "end", reason: "End not reached, remainder: '\(input)'") }
            return ((), input)
        }
    }
}

extension Parser {
    public var void: Parser<Void> {
        return map { _ in () }
    }
}
