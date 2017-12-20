
import Foundation

public extension String {
    func makeDictionary() -> [String: Any]? {
        guard let data = data(using: .utf8) else { return nil }

        return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any]
    }
}

public extension String {
    func split(at index: String.IndexDistance) -> (before: String, after: String) {
        let index = self.index(startIndex, offsetBy: index)
        return split(at: index)
    }
    func split(at index: String.Index) -> (before: String, after: String) {
        return (
            String(self[..<index]),
            String(self[index...])
        )
    }
}

public extension String {
    func components(seperatedBy separators: [String]) -> [String] {
        return separators
            .reduce([self]) { result, seperator in
                return result.flatMap { $0.components(separatedBy: seperator) }
            }
    }
}

public extension String {
    /// Returns the receiver with the provided prefix removed if found.
    /// also, optionally, removes any additional leading whitespace
    ///
    /// - Parameters:
    ///   - prefix: The prefix to remove from the receiver
    ///   - includeWhitespace: If `true` removes andy additionaly leading whitespace after `prefix`
    /// - Returns: The receiver with `prefix` and, optionally, leading whitespace removed
    func remove(prefix: String, includeWhitespace: Bool = true) -> String {
        guard !isEmpty, !prefix.isEmpty else { return self }

        var index = startIndex

        for character in prefix {
            guard character == self[index] else { return self }
            formIndex(after: &index)
        }

        guard includeWhitespace else { return String(self[index..<endIndex]) }

        while indices.contains(index) && self[index] == " " {
            formIndex(after: &index)
        }

        return String(self[index..<endIndex])
    }
}

public extension String {
    func trimCharacters(in set: Set<Character>) -> String {
        guard !isEmpty, !set.isEmpty else { return self }

        var index = startIndex

        while indices.contains(index) && set.contains(self[index]) {
            formIndex(after: &index)
        }

        return String(self[index..<endIndex])
    }
    func substring(until set: Set<Character>) -> String {
        guard !isEmpty, !set.isEmpty else { return self }

        var index = startIndex

        while indices.contains(index) && !set.contains(self[index]) {
            formIndex(after: &index)
        }

        return String(self[startIndex..<index])
    }
}

public extension String {
    /// Returns a substring of the receiver from the first `Character` up to the first found instance of the provided `Character`
    ///
    /// - Parameter value: The `Character` to look for
    /// - Returns: If the `Character` was found the new substring, otherwise `nil`
    func substring(to value: Character) -> String? {
        guard let index = index(of: value) else { return nil }
        return String(self[..<index])
    }
}

public struct RegexMatch {
    public let range: Range<String.Index>
    public let string: String

    public init(range: Range<String.Index>, string: String) {
        self.range = range
        self.string = string
    }
}

extension RegexMatch: Equatable {
    public static func ==(lhs: RegexMatch, rhs: RegexMatch) -> Bool {
        return lhs.string == rhs.string && lhs.range == rhs.range
    }
}

public extension String {
    /// Return a sequence of substrings and their ranges matching a provided regular expression
    ///
    /// - Note: Capture groups in the Regex string aren't supported
    ///
    /// - Parameter regex: The Regex pattern to match
    /// - Returns: A sequence of matched `String`s and their `Range<String.Index>`s
    func substrings(matching regex: String) -> [RegexMatch] {
        guard !regex.isEmpty else { return [] }

        var matches: [RegexMatch] = []
        var index = startIndex

        while let range = range(of: regex, options: .regularExpression, range: index..<endIndex) {
            index = range.upperBound
            matches.append(RegexMatch(range: range, string: String(self[range])))
        }

        return matches
    }

    /// Return a sequence of substrings matching a provided regular expression
    ///
    /// - Note: Capture groups in the Regex string aren't supported
    ///
    /// - Parameter regex: The Regex string to look for
    /// - Returns: A sequence of matched `String`s
    func substrings(matching regex: String) -> [String] {
        return self
            .substrings(matching: regex)
            .map { match in return match.string }
    }
}
