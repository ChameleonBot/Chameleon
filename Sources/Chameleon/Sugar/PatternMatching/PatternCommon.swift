
import Foundation

extension String {
    func stripStart(characters: [Character]) -> String {
        guard
            let first = self.first,
            characters.contains(first)
            else { return self }

        return self
            .dropFirst()
            .map { String($0) }
            .joined()
    }
    func stripEnd(characters: [Character]) -> String {
        guard
            let last = self.last,
            characters.contains(last)
            else { return self }

        return self
            .dropLast()
            .map { String($0) }
            .joined()
    }
    func strippingSyntax() -> String {
        let start: [Character] = ["[", "(", "<"]
        let end: [Character] = ["]", ")", ">"]

        return self
            .stripStart(characters: start)
            .stripEnd(characters: end)
    }
}

extension Bool {
    static let truthy = ["1", "true", "t", "yes", "yep", "yup", "yeah", "yeh", "y"]
    static let falsey = ["0", "false", "f", "nah", "nup", "nope", "no", "n"]
}
