extension Parser {
    public var optional: Parser<T?> {
        return .init { self.parse($0) ?? (nil, $0) }
    }
}

extension Parser where T: Collection {
    public func unwrap<U>() -> Parser<[U]> where T.Element == U? {
        return map { $0.compactMap { $0 } }
    }
}
