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

private enum ManyParser: Error { case complete }

extension Parser {
	public var many: Parser<[T]> {
		let notSelf = Parser<Void> { input in
			if let _ = try? self.parse(input) {
				// if self succeeds, we want to throw to
				// continue the `until`
				throw ManyParser.complete

			} else {
				// if self failed, we want to succeed to
				// end the `until`
				return (value: (), remainder: input)
			}
		}

		return until(notSelf || .end).map { $0.0 }
	}
}
