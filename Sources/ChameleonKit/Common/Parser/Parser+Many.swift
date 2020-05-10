extension Parser {
    public func until<U>(_ other: Parser<U>) -> Parser<([T], U)> {
        return .init { input in
            var remaining = input
            var values: [T] = []

            do {
                while true {
                    let value = try self.parse(remaining)
                    values.append(value.value)
                    remaining = value.remainder

                    if let second = try? other.parse(value.remainder) {
                        if values.isEmpty {
                            throw ParserError.matchFailed(name: "until", reason: "Parser did not match before 'other'")
                        } else {
                            return ((values, second.value), second.remainder)
                        }
                    }
                }

            } catch let error {
                throw ParserError.matchFailed(
                    name: "until",
                    reason: "Parser failed to match against '\(remaining)' (\(values.count) matches total): \(error)"
                )
            }
        }
    }
}
