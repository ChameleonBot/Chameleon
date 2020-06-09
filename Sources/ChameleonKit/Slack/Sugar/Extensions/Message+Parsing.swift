extension Message {
    public func matching<T>(debug: DebugLevel = .none, _ parser: Parser<T>, match: () throws -> Void) throws {
        return try matching(debug: debug, parser) { _ in try match() }
    }
    public func matching<T>(debug: DebugLevel = .none, _ parser: Parser<T>, match: (T) throws -> Void) throws {
        var errors: [Error] = []

        func result(input: Substring) -> T? {
            do {
                return try parser.parse(input).value

            } catch let error {
                errors.append(error)
                return nil
            }
        }

        for index in text.indices {
            guard let result = result(input: text[index...]) else { continue }

            return try match(result)
        }

        try debug.handle(CompositeError(errors: errors))
    }
}
