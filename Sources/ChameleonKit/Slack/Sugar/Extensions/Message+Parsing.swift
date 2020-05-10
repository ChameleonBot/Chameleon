extension Message {
    public func matching<T>(debug: Bool = false, trimWhitespace: Bool = true, _ parser: Parser<T>, match: (T) throws -> Void) throws {
        do {
            let result = try parser.parse(text[...])
            try match(result.value)

        } catch let error {
            guard debug else { return }
            print("Match Failure:", error)
        }
    }
}
