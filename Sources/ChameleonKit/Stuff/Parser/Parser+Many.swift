extension Parser {
    public func until<U>(_ other: Parser<U>) -> Parser<([T], U)> {
        return .init { input in
            var remaining = input
            var values: [T] = []

            while let value = self.parse(remaining) {
                values.append(value.value)
                remaining = value.remainder

                if let second = other.parse(value.remainder) {
                    if values.isEmpty {
                        return nil
                    } else {
                        return ((values, second.value), second.remainder)
                    }
                }
            }

            return nil
        }
    }
}
