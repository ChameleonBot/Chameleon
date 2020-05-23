extension Parser {
    public var void: Parser<Void> {
        return map { _ in () }
    }
}

extension Parser {
    public static func anyOf(_ values: [Parser]) -> Parser {
        return values.reduce(never, ||)
    }
}
