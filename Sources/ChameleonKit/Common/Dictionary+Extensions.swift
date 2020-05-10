extension Dictionary {
    public mutating func squash(from key: Key) {
        let inner = (self[key] as? Self) ?? [:]
        merge(inner, uniquingKeysWith: { a, _ in a })
    }
}
