
#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

public extension Collection where Index == Int {
    /// Returns a random element from the collection.
    var randomElement: Iterator.Element? {
        guard !self.isEmpty else { return nil }

        let min = self.startIndex
        let max = self.endIndex - self.startIndex
        #if os(Linux)
            let index = Int(Glibc.random() % max) + min
        #else
            let index = Int(arc4random_uniform(UInt32(max))) + min
        #endif

        return self[index]
    }
}

public extension Collection {
    func group<T: Hashable>(by closure: (Iterator.Element) throws -> T) rethrows -> [T: [Iterator.Element]] {
        var result: [T: [Iterator.Element]] = [:]
        for item in self {
            let key = try closure(item)
            var items = result[key] ?? []
            items.append(item)
            result[key] = items
        }
        return result
    }
}
