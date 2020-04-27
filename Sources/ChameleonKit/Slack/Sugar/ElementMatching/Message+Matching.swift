extension Array where Element == RichTextElement {
    private func matching(_ debug: Bool, _ matchers: [ElementMatcher], match: (ElementMatchQueue) throws -> Void) throws {
        guard let result = self[...].matchQueue(debug, matchers) else { return }
        try match(result.1)
    }

    public func matching(debug: Bool = false, _ matchers: [ElementMatcher], match: () throws -> Void) throws {
        try matching(debug, matchers, match: { _ in try match() })
    }
    public func matching<A>(debug: Bool = false, _ matchers: [ElementMatcher], match: (A) throws -> Void) throws {
        try matching(debug, matchers, match: { try match($0.popFirst()) })
    }
    public func matching<A, B>(debug: Bool = false, _ matchers: [ElementMatcher], match: ((A, B)) throws -> Void) throws {
        try matching(debug, matchers, match: { try match(($0.popFirst(), $0.popFirst())) })
    }
    public func matching<A, B, C>(debug: Bool = false, _ matchers: [ElementMatcher], match: ((A, B, C)) throws -> Void) throws {
        try matching(debug, matchers, match: { try match(($0.popFirst(), $0.popFirst(), $0.popFirst())) })
    }
    public func matching<A, B, C, D>(debug: Bool = false, _ matchers: [ElementMatcher], match: ((A, B, C, D)) throws -> Void) throws {
        try matching(debug, matchers, match: { try match(($0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst())) })
    }
    public func matching<A, B, C, D, E>(debug: Bool = false, _ matchers: [ElementMatcher], match: ((A, B, C, D, E)) throws -> Void) throws {
        try matching(debug, matchers, match: { try match(($0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst())) })
    }
    public func matching<A, B, C, D, E, F>(debug: Bool = false, _ matchers: [ElementMatcher], match: ((A, B, C, D, E, F)) throws -> Void) throws {
        try matching(debug, matchers, match: { try match(($0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst())) })
    }
}
