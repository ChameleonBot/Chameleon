#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

public final class Environment: KeyValueStore {
    public init() { }
    
    public func get<T: LosslessStringConvertible>(forKey key: String) throws -> T {
        guard
            let rawValue = getenv(key),
            let value = String(utf8String: rawValue)
            else { throw KeyValueStoreError.missing(key: key) }

        guard let result = T(value) else { throw KeyValueStoreError.invalid(key: key, expected: T.self, found: value) }

        return result
    }
    public func set<T: LosslessStringConvertible>(value: T, forKey key: String) {
        setenv(key, value.description, 1)
    }
    public func remove(key: String) {
        unsetenv(key)
    }
}
