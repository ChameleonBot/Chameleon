import Foundation

extension Parser {
    public static var char: Parser<Character> {
        return char(where: { _ in true })
    }

    public static func char(_ character: Character) -> Parser<Character> {
        return char(where: { $0 == character })
    }

    public static func char(in set: CharacterSet) -> Parser<Character> {
        return char(where: set.contains)
    }

    public static func char(where predicate: @escaping (Character) -> Bool) -> Parser<Character> {
        return .init { input in
            guard let char = input.first else { throw ParserError.matchFailed(name: "char", reason: "No more characters") }
            guard predicate(char) else {
                throw ParserError.matchFailed(name: "char", reason: "Predicate failed")
            }
            return (char, input.dropFirst())
        }
    }

    public static var newline: Parser<Character> {
        return .char(where: { $0.isNewline })
    }
    public static var whitespace: Parser<Character> {
        return .char(where: { $0.isWhitespace })
    }
}

extension Parser where T == [Character] {
    public var string: Parser<String> { return map { String($0) } }
}

extension CharacterSet {
    public func contains(_ character: Character) -> Bool {
        guard let value = character.unicodeScalars.first else { return false }
        return contains(value)
    }
}
