import Foundation

struct ModelPointerMatcher<T: IDRepresentable>: Matcher {
    let token: String

    func match(against input: String) -> Match? {
        let prefix = "<\(self.token)"
        let separator: Character = "|"
        let suffix: Character = ">"

        guard
            let value = input.components(separatedBy: " ").first,
            value.hasPrefix(prefix),
            value.hasSuffix(String(suffix)),
            let end = value.index(of: separator) ?? value.index(of: suffix)
            else { return nil }

        return Match(
            key: nil,
            value: ModelPointer<T>(id: String(value[prefix.endIndex..<end])),
            matched: value
        )
    }

    var matcherDescription: String {
        return "(\(T.self))"
    }
}
extension ModelPointerType where ModelType: TokenRepresentable {
    public static var any: Matcher {
        return ModelPointerMatcher<ModelType>(token: ModelType.token)
    }
}

extension BotUser: TypeMatcher {
    public static var any: Matcher {
        return ModelPointerMatcher<BotUser>(token: token)
    }
}

extension User: TypeMatcher {
    public static var any: Matcher {
        return ModelPointerMatcher<User>(token: token)
    }
}

extension Channel: TypeMatcher {
    public static var any: Matcher {
        return ModelPointerMatcher<Channel>(token: token)
    }
}

extension Group: TypeMatcher {
    public static var any: Matcher {
        return ModelPointerMatcher<Group>(token: token)
    }
}
