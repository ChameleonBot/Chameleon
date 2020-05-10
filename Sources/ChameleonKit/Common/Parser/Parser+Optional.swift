extension Parser {
    public var optional: Parser<T?> {
        return .init {
            do { return try self.parse($0) }
            catch { return (nil, $0) }
        }
    }
}

public func optional<T>(_ parser: Parser<T>) -> Parser<T?> {
    return parser.optional
}

extension Parser where T: Collection, T.Element: OptionalType {
    public func unwrap() -> Parser<[T.Element.WrappedType]> {
        return map { $0.compactMap { $0.wrapped } }
    }
}
