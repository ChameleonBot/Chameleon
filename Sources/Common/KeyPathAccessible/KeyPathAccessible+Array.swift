
extension Array: KeyPathAccessible {
    public func value<T>(at key: KeyPathComponent) throws -> T {
        guard let itemKey = key as? Index else { throw KeyPathError.invalid(key: [key]) }

        guard itemKey >= startIndex && itemKey < endIndex else { throw KeyPathError.missing(key: [key]) }

        let value = self[itemKey]
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

    extension NSArray: KeyPathAccessible {
        public func value<T>(at key: KeyPathComponent) throws -> T {
            return try (self as Array).value(at: key)
        }
        public func path(at key: KeyPathComponent) throws -> KeyPathAccessible {
            return try (self as Array).path(at: key)
        }
    }
#endif
