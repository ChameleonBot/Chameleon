extension Array where Element == RichTextElement {
    private func matchingAll(_ debug: DebugLevel, _ trimWhitespace: Bool, _ matchers: [ElementMatcher], match: ([ElementMatchQueue]) throws -> Void) throws {
        var queues: [ElementMatchQueue] = []
        var elements = self[...]

        while let (remaining, match) = try elements.matchQueue(debug, trimWhitespace, matchers) {
            elements = remaining
            queues.append(match)
        }

        guard !queues.isEmpty else { return }
        try match(queues)
    }

    public func matchingAll<A>(debug: DebugLevel = .none, trimWhitespace: Bool = true, _ matchers: [ElementMatcher], match: ([A]) throws -> Void) throws {
        try matchingAll(debug, trimWhitespace, matchers, match: { try match($0.map({ try $0.popFirst() })) })
    }
    public func matchingAll<A, B>(debug: DebugLevel = .none, trimWhitespace: Bool = true, _ matchers: [ElementMatcher], match: ([(A, B)]) throws -> Void) throws {
        try matchingAll(debug, trimWhitespace, matchers, match: { try match($0.map({ try ($0.popFirst(), $0.popFirst()) })) })
    }
    public func matchingAll<A, B, C>(debug: DebugLevel = .none, trimWhitespace: Bool = true, _ matchers: [ElementMatcher], match: ([(A, B, C)]) throws -> Void) throws {
        try matchingAll(debug, trimWhitespace, matchers, match: { try match($0.map({ try ($0.popFirst(), $0.popFirst(), $0.popFirst()) })) })
    }
    public func matchingAll<A, B, C, D>(debug: DebugLevel = .none, trimWhitespace: Bool = true, _ matchers: [ElementMatcher], match: ([(A, B, C, D)]) throws -> Void) throws {
        try matchingAll(debug, trimWhitespace, matchers, match: { try match($0.map({ try ($0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst()) })) })
    }
    public func matchingAll<A, B, C, D, E>(debug: DebugLevel = .none, trimWhitespace: Bool = true, _ matchers: [ElementMatcher], match: ([(A, B, C, D, E)]) throws -> Void) throws {
        try matchingAll(debug, trimWhitespace, matchers, match: { try match($0.map({ try ($0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst()) })) })
    }
    public func matchingAll<A, B, C, D, E, F>(debug: DebugLevel = .none, trimWhitespace: Bool = true, _ matchers: [ElementMatcher], match: ([(A, B, C, D, E, F)]) throws -> Void) throws {
        try matchingAll(debug, trimWhitespace, matchers, match: { try match($0.map({ try ($0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst()) })) })
    }
}
