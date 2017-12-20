
public protocol ModelMatcher: Matcher, TokenRepresentable {
    var matcher: Matcher { get }
}

public extension ModelMatcher where Self: IDRepresentable & Nameable {
    var matcher: Matcher {
        let pattern = "<\(Self.token)\(id)>"

        return ValueMatcher(
            value: self,
            matches: [pattern]
        )
    }
    func match(against input: String) -> Match? {
        return matcher.match(against: input)
    }
    var matcherDescription: String {
        return "(\(Self.token)\(name))"
    }
}

extension BotUser: ModelMatcher { }
extension User: ModelMatcher { }
extension Channel: ModelMatcher { }
extension Group: ModelMatcher { }
