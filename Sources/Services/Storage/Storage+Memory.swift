
public final class MemoryStorage: Storage {
    // MARK: - Private
    private let store = MemoryKeyValueStore()

    // MARK: - Lifecycle
    public init() { }

    // MARK: - Public
    public func get<T: LosslessStringConvertible>(key: String, from namespace: String) throws -> T {
        return try execute { try store.get(forKey: namespaced(namespace, key)) }
    }
    public func set<T: LosslessStringConvertible>(value: T, forKey key: String, in namespace: String) {
        execute { store.set(value: value, forKey: namespaced(namespace, key)) }
    }
    public func remove(key: String, from namespace: String) {
        execute { store.remove(key: namespaced(namespace, key)) }
    }
    public func keys(in namespace: String) throws -> [String] {
        return Array(store.storage.keys).map { $0.remove(prefix: namespaced(namespace, "")) }
    }

    public func removeAll() {
        store.removeAll()
    }
}
