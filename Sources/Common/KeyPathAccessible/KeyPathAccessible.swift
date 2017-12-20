
public enum KeyPathError: Error, CustomStringConvertible {
    case invalid(key: [KeyPathComponent])
    case missing(key: [KeyPathComponent])
    case mismatch(key: [KeyPathComponent], expected: Any.Type, found: Any.Type)

    public var description: String {
        switch self {
        case .invalid(let keyPath):
            return "Invalid keyPath provided: '\(keyPath)'"
        case .missing(let keyPath):
            return "KeyPath not found at: '\(keyPath)'"
        case .mismatch(let keyPath, let expected, let found):
            return "Type mismatch at: '\(keyPath)' - Expected: \(expected), found: \(found)"
        }
    }
}

public protocol KeyPathAccessible {
    func value<T>(at key: KeyPathComponent) throws -> T
    func path(at key: KeyPathComponent) throws -> KeyPathAccessible
}
