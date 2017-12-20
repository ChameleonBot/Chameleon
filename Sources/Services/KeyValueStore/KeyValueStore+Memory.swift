
public final class MemoryKeyValueStore: KeyValueStore {
    private(set) var storage: [String: String] = [:]

    public init() { }

    public func get<T: LosslessStringConvertible>(forKey key: String) throws -> T {
        guard let value = storage[key] else { throw KeyValueStoreError.missing(key: key) }

        guard
            let result = T(value)
            else { throw KeyValueStoreError.invalid(key: key, expected: T.self, found: value) }

        return result
    }
    public func set<T: LosslessStringConvertible>(value: T, forKey key: String) {
        storage[key] = value.description
    }
    public func remove(key: String) {
        storage.removeValue(forKey: key)
    }

    public func removeAll() {
        storage.removeAll()
    }
}
