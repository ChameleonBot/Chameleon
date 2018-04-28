import Foundation

public extension MessageDecorator {
    public struct Link<T> {
        public let range: Range<String.Index>
        public let value: T
    }
}

public extension MessageDecorator {
    var mentionedUsers: [Link<ModelPointer<User>>] {
        return buildLinks { match in
            guard match.string.hasPrefix("@U") else { return nil }

            return ModelPointer<User>(id:
                String(match.string[match.string.index(after: match.string.startIndex)...])
            )
        }
    }
    var mentionedChannels: [Link<ModelPointer<Channel>>] {
        return buildLinks { match in
            guard match.string.hasPrefix("#C") else { return nil }

            return ModelPointer<Channel>(id:
                String(match.string[match.string.index(after: match.string.startIndex)...])
            )
        }
    }
    var mentionedGroups: [Link<ModelPointer<Group>>] {
        return buildLinks { match in
            guard match.string.hasPrefix("G") else { return nil }

            return ModelPointer<Group>(id: match.string)
        }
    }
    var mentionedCommands: [Link<Command>] {
        return buildLinks { match in
            return Command(rawValue: match.string)
        }
    }
    var mentionedLinks: [Link<(title: String, link: String)>] {
        let ignoredTokens = ["@", "#", "!", "G"]

        return buildLinks { match in
            let token = String(match.string[match.string.startIndex])

            guard !ignoredTokens.contains(token) else { return nil }

            let components = match.string.components(separatedBy: "|")

            guard
                let first = components.first,
                let last = components.last
                else { return nil }

            return (first, last)
        }
    }
}

private extension MessageDecorator {
    func buildLinks<T>(factory: (RegexMatch) -> T?) -> [Link<T>] {
        let links: [RegexMatch] = text.substrings(matching: "<(.*?)>")

        return links
            .map { match -> RegexMatch in
                //TODO: needed because capture groups aren't currently supported
                // written in a way that if this code is left in by mistake
                // nothing will break
                var range = match.range
                if match.string.hasPrefix("<") {
                    range = text.index(after: range.lowerBound)..<range.upperBound
                }
                if match.string.hasSuffix(">") {
                    range = range.lowerBound..<text.index(before: range.upperBound)
                }

                return RegexMatch(range: range, string: String(text[range]))
            }
            .compactMap { match in
                guard let value = factory(match) else { return nil }
                return Link(range: match.range, value: value)
        }
    }
}
