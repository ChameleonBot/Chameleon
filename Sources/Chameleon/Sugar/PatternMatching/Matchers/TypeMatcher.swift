
/// Defines a specialised `Matcher` that matches wildcard representations of vaious types
public protocol TypeMatcher {
    static var any: Matcher { get }
}

extension String: TypeMatcher {
    public static var any: Matcher {
        return DynamicMatcher(
            greedy: true,
            match: { input in
                guard !input.isEmpty else { return nil }

                return Match(
                    key: nil,
                    value: input,
                    matched: input
                )
            }
        )
    }
}
extension Int: TypeMatcher {
    public static var any: Matcher {
        return DynamicMatcher(
            greedy: false,
            match: { input in
                guard
                    let first = input.components(separatedBy: " ").first,
                    let value = Int(first)
                    else { return nil }

                return Match(
                    key: nil,
                    value: value,
                    matched: String(input[input.startIndex..<first.endIndex])
                )
            }
        )
    }
}
extension Bool: TypeMatcher {
    public static var any: Matcher {
        return DynamicMatcher(
            greedy: false,
            match: { input in
                if let value = truthy.first(where: input.hasPrefix) {
                    return Match(key: nil, value: true, matched: value)
                } else if let value = falsey.first(where: input.hasPrefix) {
                    return Match(key: nil, value: false, matched: value)
                }

                return nil

            }
        )
    }
}
