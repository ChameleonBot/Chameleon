extension Parser {
    public var void: Parser<Void> {
        return map { _ in () }
    }
}
