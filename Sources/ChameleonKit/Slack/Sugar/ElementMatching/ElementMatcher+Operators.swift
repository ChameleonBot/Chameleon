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
