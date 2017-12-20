
/// Represents a matched `String` and its underlying value
public struct Match {
    /// The key associated with this `Match`
    public let key: String?

    /// The _raw_ data representing the matched `String`
    public let value: Any

    /// The `String` that was matched in the pattern
    public let matched: String

    public init(key: String?, value: Any, matched: String) {
        self.key = key
        self.value = value
        self.matched = matched
    }

    func with(key: String) -> Match {
        return Match(key: key, value: value, matched: matched)
    }
}
