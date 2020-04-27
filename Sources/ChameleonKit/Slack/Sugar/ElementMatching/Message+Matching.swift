extension AnyCollection where Element == RichTextElement {
    func matchQueue(_ matchers: [ElementMatcher]) -> (AnyCollection<RichTextElement>, ElementMatchQueue)? {
        guard let firstMatcher = matchers.first else { return nil }

        // find the first match to get a starting point
        for index in indices {
            switch firstMatcher.match(self[index...]) {
            case nil:
                continue

            case (let value, var remaining)?:
                // first one found, move forward from here
                var values = value

                let remainingMatchers = matchers.dropFirst()
                for matcher in remainingMatchers {
                    guard let match = matcher.match(remaining) else { return nil }

                    values.append(contentsOf: match.values)
                    remaining = match.remaining
                }

                let availableValues = values.filter { !($0 is NoValue) }
                return (remaining, ElementMatchQueue(availableValues))
            }
        }

        return nil
    }
}

extension Array where Element == RichTextElement {
    private func matching(_ matchers: [ElementMatcher], match: (ElementMatchQueue) throws -> Void) throws {
        guard let result = AnyCollection(self).matchQueue(matchers) else { return }
        try match(result.1)
    }

    public func matching(_ matchers: [ElementMatcher], match: () throws -> Void) throws {
        try matching(matchers, match: { _ in try match() })
    }
    public func matching<A>(_ matchers: [ElementMatcher], match: (A) throws -> Void) throws {
        try matching(matchers, match: { try match($0.popFirst()) })
    }
    public func matching<A, B>(_ matchers: [ElementMatcher], match: ((A, B)) throws -> Void) throws {
        try matching(matchers, match: { try match(($0.popFirst(), $0.popFirst())) })
    }
    public func matching<A, B, C>(_ matchers: [ElementMatcher], match: ((A, B, C)) throws -> Void) throws {
        try matching(matchers, match: { try match(($0.popFirst(), $0.popFirst(), $0.popFirst())) })
    }
    public func matching<A, B, C, D>(_ matchers: [ElementMatcher], match: ((A, B, C, D)) throws -> Void) throws {
        try matching(matchers, match: { try match(($0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst())) })
    }
    public func matching<A, B, C, D, E>(_ matchers: [ElementMatcher], match: ((A, B, C, D, E)) throws -> Void) throws {
        try matching(matchers, match: { try match(($0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst())) })
    }
    public func matching<A, B, C, D, E, F>(_ matchers: [ElementMatcher], match: ((A, B, C, D, E, F)) throws -> Void) throws {
        try matching(matchers, match: { try match(($0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst())) })
    }
}

class ElementMatchQueue {
    private var values: AnyCollection<Any>

    init(_ values: [Any]) {
        self.values = AnyCollection(values)
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
