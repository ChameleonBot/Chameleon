
extension Dictionary: KeyPathAccessible {
    public func value<T>(at key: KeyPathComponent) throws -> T {
        guard let itemKey = key as? Key else { throw KeyPathError.invalid(key: [key]) }

        guard let value = self[itemKey] else { throw KeyPathError.missing(key: [key]) }

        guard let typedValue = value as? T
            else { throw KeyPathError.mismatch(key: [key], expected: T.self, found: type(of: value)) }

        return typedValue
    }

    public func path(at key: KeyPathComponent) throws -> KeyPathAccessible {
        return try value(at: key)
    }
}

#if !os(Linux)
    import Foundation

    extension NSDictionary: KeyPathAccessible {
        public func value<T>(at key: KeyPathComponent) throws -> T {
            return try (self as Dictionary).value(at: key)
        }
        public func path(at key: KeyPathComponent) throws -> KeyPathAccessible {
            return try (self as Dictionary).path(at: key)
        }
    }
#endif
