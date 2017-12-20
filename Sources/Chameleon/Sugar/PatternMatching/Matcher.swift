
/// Represents an object that can extract a single match from the provided input
public protocol Matcher {
    /// Attempt to find a match from the _start_ of the input
    func match(against input: String) -> Match?

    /// When `true` this matcher will used to match as much of the input as possible
    /// otherwise it will complete with the smallest amount of the input
    ///
    /// - Default: `false`
    var greedy: Bool { get }

    /// Returns a `String` that represents the _specification_ of this `Matcher`
    var matcherDescription: String { get }
}

public extension Matcher {
    var greedy: Bool { return false }
}
