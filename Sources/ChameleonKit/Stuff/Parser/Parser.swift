public struct Parser<T> {
    public typealias Result = (value: T, remainder: Substring)
    public typealias Function = (Substring) -> Result?

    public let parse: Function

    public init(parse: @escaping Function) {
        self.parse = parse
    }
}

extension Parser {
    public static var never: Parser { .init { _ in nil } }

    public static func just(_ value: T) -> Parser { .init { (value, $0) } }
}

extension Parser {
    public func map<U>(_ transform: @escaping (T) -> U) -> Parser<U> {
        return .init { input in
            self.parse(input).map { (transform($0.value), $0.remainder) }
        }
    }

    public func flatMap<U>(_ transform: @escaping (T) -> Parser<U>) -> Parser<U> {
        return .init { input in
            guard let result = self.parse(input) else { return nil }
            return transform(result.value).parse(result.remainder)
        }
    }
}

extension Parser {
    public func or(_ other: Parser) -> Parser {
        return .init { input in
            return self.parse(input) ?? other.parse(input)
        }
    }
}
