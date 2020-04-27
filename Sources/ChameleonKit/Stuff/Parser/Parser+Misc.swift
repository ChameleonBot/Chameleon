extension Parser where T == Void {
    public static var end: Parser {
        return .init { input in
            guard input.isEmpty else { return nil }
            return ((), input)
        }
    }
}

extension Parser {
    public var void: Parser<Void> {
        return map { _ in () }
    }
}

extension Parser {
    public func filter(_ predicate: @escaping (T) -> Bool) -> Parser {
        return flatMap { value in
            return predicate(value) ? .just(value) : .never
        }
    }
}
