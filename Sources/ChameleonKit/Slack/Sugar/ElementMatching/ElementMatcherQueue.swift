extension ArraySlice where Element == RichTextElement {
    func matchQueue(_ debug: Bool, _ matchers: [ElementMatcher]) -> (ArraySlice<RichTextElement>, ElementMatchQueue)? {
        guard let firstMatcher = matchers.first else { return nil }

        var firstError: Error?
        // find the first match to get a starting point
        for index in indices {
            firstError = nil

            do {
                let firstMatch = try firstMatcher.match(self[index...])
                var remaining = firstMatch.remaining

                // first one found, move forward from here
                var values = firstMatch.values

                let remainingMatchers = matchers.dropFirst()
                for matcher in remainingMatchers {
                    do {
                        let match = try matcher.match(remaining)

                        values.append(contentsOf: match.values)
                        remaining = match.remaining

                    } catch let error {
                        guard debug else { return nil }

                        print("Match Failure:", error)
                        return nil
                    }
                }

                let availableValues = values.filter { !($0 is NoValue) }
                return (remaining, ElementMatchQueue(availableValues))

            } catch let error {
                firstError = error
                continue
            }
        }

        if debug, let firstError = firstError {
            print("Match Failure:", firstError)
        }

        return nil
    }
}

class ElementMatchQueue {
    private var values: ArraySlice<Any>

    init(_ values: [Any]) {
        self.values = values[...]
    }

    func popFirst<T>() throws -> T {
        //        if let value = values.first(where: { $0 is T }) {
        //            values = values.dropFirst()
        //            return value as! T
        //        }
        if let value = values.first as? T {
            values = values.dropFirst()
            return value

        } else {
            throw ElementMatcher.Error.typeMismatch(expected: T.self, value: values.first)
        }
    }
}

extension Message.Layout.RichText.Element.Text {
    func withoutWhitespace() -> Message.Layout.RichText.Element.Text {
        var copy = self
        copy.text = text.replacingOccurrences(of: " ", with: "")
        return copy
    }
}
