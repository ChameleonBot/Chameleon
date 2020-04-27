prefix operator ^
postfix operator ^ // $ isn't usable as an operator

extension ElementMatcher {
    public static prefix func ^(matcher: ElementMatcher) -> ElementMatcher {
        return .start && matcher
    }
    public static postfix func ^(matcher: ElementMatcher) -> ElementMatcher {
        return .end && matcher
    }
}

extension ElementMatcher {
    public static var start: ElementMatcher {
        return .init { elements in
            guard elements.startIndex == 0 else {
                throw Error.matchFailed(name: "start", reason: "elements.startIndex == \(elements.startIndex)")
            }
            return ([NoValue()], elements)
        }
    }
    public static var end: ElementMatcher {
        return .init { elements in
            guard elements.index(after: elements.startIndex) == elements.endIndex else  {
                throw Error.matchFailed(name: "end", reason: "elements.startIndex == \(elements.startIndex)")
            }
            return ([NoValue()], elements)
        }
    }
}
