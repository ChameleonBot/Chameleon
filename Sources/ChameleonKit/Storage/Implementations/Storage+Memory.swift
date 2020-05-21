public class MemoryStorage: Storage {
    private let keyValue = MemoryKeyValueStorage()

    public init() { }

    public func get<T: LosslessStringConvertible>(forKey key: String, from namespace: String) throws -> T {
        return try keyValue.get(forKey: namespaced(namespace, key))
    }
    public func set<T: LosslessStringConvertible>(forKey key: String, from namespace: String, value: T) throws {
        try keyValue.set(value: value, forKey: namespaced(namespace, key))
    }
    public func remove(forKey key: String, from namespace: String) throws {
        try keyValue.remove(forKey: namespaced(namespace, key))
    }

    // MARK: - Private Functions
    private func namespaced(_ namespace: String, _ key: String) -> String {
        return "\(namespace):\(key)"
    }
}
