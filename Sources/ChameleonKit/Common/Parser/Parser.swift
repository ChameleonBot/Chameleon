public enum ParserError: Swift.Error {
    case matchFailed(name: String, reason: String)
}

public struct Parser<T> {
    public typealias Result = (value: T, remainder: Substring)
    public typealias Function = (Substring) throws -> Result

    public let parse: Function

    public init(parse: @escaping Function) {
        self.parse = parse
    }
}

//extension Parser {
////    public static var never: Parser { .init { _ in nil } }
//
//    public static func just(_ value: T) -> Parser { .init { (value, $0) } }
//}

extension Parser {
    public func map<U>(_ transform: @escaping (T) -> U) -> Parser<U> {
        return .init { input in
            let match = try self.parse(input)
            return (transform(match.value), match.remainder)
        }
    }

    public func flatMap<U>(_ transform: @escaping (T) -> Parser<U>) -> Parser<U> {
        return .init { input in
            let result = try self.parse(input)
            return try transform(result.value).parse(result.remainder)
        }
    }
}

extension Parser {
    public func or(_ other: Parser) -> Parser {
        return .init { input in
            do {
                return try self.parse(input)
            } catch {
                return try other.parse(input)
            }
        }
    }
}
