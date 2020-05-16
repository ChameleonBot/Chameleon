precedencegroup ParserOperatorGroup {
    associativity: left
    lowerThan: LogicalConjunctionPrecedence
}

infix operator *>: ParserOperatorGroup
infix operator <*: ParserOperatorGroup
infix operator <*>: ParserOperatorGroup

public func *><A, B>(a: Parser<A>, b: Parser<B>) -> Parser<B> {
    return a.flatMap { _ in b.map { $0 } }
}
public func <*<A, B>(a: Parser<A>, b: Parser<B>) -> Parser<A> {
    return a.flatMap { a in b.map { _ in a } }
}

public func <*><A, B>(a: Parser<A>, b: Parser<B>) -> Parser<String> {
    return (a && Parser<Character>.char.until(b)).map { String($0.1.0) }
}

public func &&<A, B>(a: Parser<A>, b: Parser<B>) -> Parser<(A, B)> {
    return a.flatMap { a in b.map { (a, $0) } }
}
public func &&<A, B, C>(a: Parser<(A, B)>, c: Parser<C>) -> Parser<(A, B, C)> {
    return a.flatMap { ab in c.map { (ab.0, ab.1, $0) } }
}

public func ||<A>(lhs: Parser<A>, rhs: Parser<A>) -> Parser<A> {
    return lhs.or(rhs)
}

extension Parser {
    public static prefix func ^(parser: Parser) -> Parser {
        return .start *> parser
    }
    public static postfix func ^(parser: Parser) -> Parser {
        return parser <* .end 
    }
}
