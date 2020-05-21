public class MemoryStorage: Storage {
    private let keyValue = MemoryKeyValueStorage()

    public init() { }

    public func get<T: LosslessStringConvertible>(forKey key: String, from namespace: String) throws -> T {
        return try exec { try keyValue.get(forKey: namespaced(namespace, key)) }
    }
    public func set<T: LosslessStringConvertible>(forKey key: String, from namespace: String, value: T) throws {
        try exec { try keyValue.set(value: value, forKey: namespaced(namespace, key)) }
    }
    public func remove(forKey key: String, from namespace: String) throws {
        try exec { try keyValue.remove(forKey: namespaced(namespace, key)) }
    }

    // MARK: - Private Functions
    private func namespaced(_ namespace: String, _ key: String) -> String {
        return "\(namespace):\(key)"
    }
    private func exec<T>(_ closure: () throws -> T) throws -> T {
        do {
            return try closure()

        } catch KeyValueStorageError.missing(let key) {
            throw StorageError.missing(key: key)

        } catch KeyValueStorageError.invalid(let key, let expected, let found) {
            throw StorageError.invalid(key: key, expected: expected, found: found)
        }
    }
}
