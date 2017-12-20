
/// Defines a specialised `Matcher` that matches `String` representations of the values of various instances
public protocol InstanceMatcher: Matcher {
    var matcher: Matcher { get }
}
public extension InstanceMatcher {
    var matcher: Matcher {
        return ValueMatcher(
            value: self,
            matches: [String(describing: self)]
        )
    }
    func match(against input: String) -> Match? {
        return matcher.match(against: input)
    }
    var matcherDescription: String {
        return matcher.matcherDescription
    }
}

extension String: InstanceMatcher { }
extension Int: InstanceMatcher { }
extension Bool: InstanceMatcher {
    public var matcher: Matcher {
        switch self {
        case true: return ValueMatcher(value: self, matches: Bool.truthy)
        case false: return ValueMatcher(value: self, matches: Bool.falsey)
        }
    }
}
