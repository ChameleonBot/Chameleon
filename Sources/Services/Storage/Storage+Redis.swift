import Redis
import Foundation

public final class RedisStorage: Storage {
    // MARK: - Private Properties
    private let keyValueStore: RedisKeyValueStore

    // MARK: - Lifecycle
    public init(hostname: String, port: UInt16, password: String? = nil, database: String? = nil) {
        self.keyValueStore = RedisKeyValueStore(hostname: hostname, port: port, password: password, database: database)
    }
    public init(url: String) {
        self.keyValueStore = RedisKeyValueStore(url: url)
    }

    // MARK: - Public Functions
    public func get<T: LosslessStringConvertible>(key: String, from namespace: String) throws -> T {
        return try execute { try keyValueStore.get(forKey: namespaced(namespace, key)) }
    }
    public func set<T: LosslessStringConvertible>(value: T, forKey key: String, in namespace: String) {
        execute { keyValueStore.set(value: value, forKey: namespaced(namespace, key)) }
    }
    public func remove(key: String, from namespace: String) {
        execute { keyValueStore.remove(key: namespaced(namespace, key)) }
    }
    public func keys(in namespace: String) throws -> [String] {
        let instance = try keyValueStore.factory()

        guard let dataArray = try instance.command(.keys, [namespaced(namespace, "*")])?.array else { return [] }

        return dataArray.compactMap { $0?.string?.remove(prefix: namespaced(namespace, "")) }
    }
}
