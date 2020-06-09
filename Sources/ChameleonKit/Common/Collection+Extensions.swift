extension Collection {
    public func unzip<A, B>() -> ([A], [B]) where Element == (A, B) {
        reduce(into: ([A](), [B]())) { $0.0.append($1.0); $0.1.append($1.1) }
    }
}
