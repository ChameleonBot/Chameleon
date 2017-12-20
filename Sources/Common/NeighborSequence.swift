import Foundation

/// A collection that returns the current element as well as the previous and next elements when available
public struct NeighborSequence<Base: Sequence>: Sequence, IteratorProtocol {
    public typealias Element = (previous: Base.Element?, current: Base.Element, next: Base.Element?)

    private var base: Base.Iterator
    private var previous, current: Base.Element?

    fileprivate init(_ base: Base) {
        self.base = base.makeIterator()
        self.current = self.base.next()
    }

    public mutating func next() -> Element? {
        guard let current = current else { return nil }
        defer { previous = current }

        let next = base.next()
        self.current = next

        return (previous, current, next)
    }
}

public extension RandomAccessCollection {
    /// Return `Self` as a `NeighborSequence`
    ///
    /// Each element in a `NeighborSequence` returns the element at the specified
    /// index as well as the previous and next elements when possible.
    ///
    /// This allows you to see either side of a given element.
    var neighbors: NeighborSequence<Self> {
        return NeighborSequence(self)
    }
}
