extension ArraySlice where Element == RichTextElement {
    func matchQueue(_ debug: DebugLevel, _ trimWhitespace: Bool, _ matchers: [ElementMatcher]) throws -> (ArraySlice<RichTextElement>, ElementMatchQueue)? {
        guard let firstMatcher = matchers.first else { return nil }

        let elements: [RichTextElement] = map { element in
            guard var textElement = element as? Message.Layout.RichText.Element.Text else { return element }
            if trimWhitespace {
                textElement.text = textElement.text.trimmingCharacters(in: .whitespaces)
            }
            return textElement
        }

        var errors: [Error] = []

        func findFirst() -> ElementMatcher.Match? {
            for index in elements.indices {
                do {
                    return try firstMatcher.match(elements[index...])

                } catch let error {
                    errors.append(error)
                }
            }
            return nil
        }

        if let firstMatch = findFirst() {
            // first one found, move forward from here

            var remaining = firstMatch.remaining
            var values = firstMatch.values

            let remainingMatchers = matchers.dropFirst()
            for matcher in remainingMatchers {
                do {
                    let match = try matcher.match(remaining)

                    values.append(contentsOf: match.values)
                    remaining = match.remaining

                } catch {
                    // we found the first match, but the subsequent elements were not matched
                    // so we start over looking for the 'first' match starting past the initial first element
                    return try remaining.matchQueue(debug, trimWhitespace, matchers)
                }
            }

            let availableValues = values.filter { !($0 is NoValue) }
            return (remaining, ElementMatchQueue(availableValues))

        } else {
            try debug.handle(CompositeError(errors: errors))
            return nil
        }
    }
}

class ElementMatchQueue {
    private var values: ArraySlice<Any>

    init(_ values: [Any]) {
        self.values = values[...]
    }

    func popFirst<T>() throws -> T {
        if let value = values.first as? T {
            values = values.dropFirst()
            return value

        } else {
            throw ElementMatcher.Error.typeMismatch(expected: T.self, value: values.first)
        }
    }
}
