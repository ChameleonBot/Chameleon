import Foundation

extension Parser {
    public static var char: Parser<Character> {
        return .init { input in
            guard let char = input.first else { return nil }
            return (char, input.dropFirst())
        }
    }

    public static func char(_ character: Character) -> Parser<Character> {
        return char(where: { $0 == character })
    }

    public static func char(in set: CharacterSet) -> Parser<Character> {
        return char(where: set.contains)
    }

    public static func char(where predicate: @escaping (Character) -> Bool) -> Parser<Character> {
        return char.filter(predicate)
    }

    public static var newline: Parser<Character> {
        return .char(where: { $0.isNewline })
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
