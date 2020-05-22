extension String {
    public func drop(prefix: String) -> String {
        var start = startIndex

        for (char, index) in zip(prefix, indices) {
            guard self[index] == char else { return self }
            start = index
        }

        return start == startIndex ? self : String(self[index(after: start)...])
    }
}
