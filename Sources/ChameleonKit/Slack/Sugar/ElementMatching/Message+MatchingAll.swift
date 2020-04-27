extension Array where Element == RichTextElement {
    private func matchingAll(_ matchers: [ElementMatcher], match: ([ElementMatchQueue]) throws -> Void) throws {
        var queues: [ElementMatchQueue] = []
        var elements = AnyCollection<RichTextElement>(self)

        while let (remaining, match) = elements.matchQueue(matchers) {
            elements = remaining
            queues.append(match)
        }

        guard !queues.isEmpty else { return }
        try match(queues)
    }

    public func matchingAll<A>(_ matchers: [ElementMatcher], match: ([A]) throws -> Void) throws {
        try matchingAll(matchers, match: { try match($0.map({ try $0.popFirst() })) })
    }
    public func matchingAll<A, B>(_ matchers: [ElementMatcher], match: ([(A, B)]) throws -> Void) throws {
        try matchingAll(matchers, match: { try match($0.map({ try ($0.popFirst(), $0.popFirst()) })) })
    }
    public func matchingAll<A, B, C>(_ matchers: [ElementMatcher], match: ([(A, B, C)]) throws -> Void) throws {
        try matchingAll(matchers, match: { try match($0.map({ try ($0.popFirst(), $0.popFirst(), $0.popFirst()) })) })
    }
    public func matchingAll<A, B, C, D>(_ matchers: [ElementMatcher], match: ([(A, B, C, D)]) throws -> Void) throws {
        try matchingAll(matchers, match: { try match($0.map({ try ($0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst()) })) })
    }
    public func matchingAll<A, B, C, D, E>(_ matchers: [ElementMatcher], match: ([(A, B, C, D, E)]) throws -> Void) throws {
        try matchingAll(matchers, match: { try match($0.map({ try ($0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst()) })) })
    }
    public func matchingAll<A, B, C, D, E, F>(_ matchers: [ElementMatcher], match: ([(A, B, C, D, E, F)]) throws -> Void) throws {
        try matchingAll(matchers, match: { try match($0.map({ try ($0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst(), $0.popFirst()) })) })
    }
}
