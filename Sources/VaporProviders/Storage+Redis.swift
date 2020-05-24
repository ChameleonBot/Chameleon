import ChameleonKit
import Redis

public class RedisStorage: Storage {
    private let keyValueStore: RedisKeyValueStorage

    // MARK: - Lifecycle
    public init(hostname: String, port: Int, password: String?, database: Int?) {
        self.keyValueStore = RedisKeyValueStorage(hostname: hostname, port: port, password: password, database: database)
    }
    public init(url: URL) {
        self.keyValueStore = RedisKeyValueStorage(url: url)
    }

    // MARK: - Public Functions
    public func get<T: LosslessStringConvertible>(_: T.Type, forKey key: String, from namespace: String) throws -> T {
        return try exec { try keyValueStore.get(forKey: namespaced(namespace, key)) }
    }
    public func getAll<T: LosslessStringConvertible>(_: T.Type, forKeys keys: [String], from namespace: String) throws -> [T] {
        return try exec {
            return  try keyValueStore.raw { client in
                return try client.mget(keys.map { namespaced(namespace, $0) }).wait().map { data in
                    let string = data.string ?? ""
                    guard let value = T(string) else { throw RedisError.invalidValue(expected: T.self, value: string) }
                    return value
                }
            }
        }
    }
    public func set<T: LosslessStringConvertible>(forKey key: String, from namespace: String, value: T) throws {
        try exec { try keyValueStore.set(value: value, forKey: namespaced(namespace, key)) }
    }
    public func remove(forKey key: String, from namespace: String) throws {
        try exec { try keyValueStore.remove(forKey: namespaced(namespace, key)) }
    }
    public func keys(in namespace: String) throws -> [String] {
        return try exec {
            return  try keyValueStore.raw { client in
                let redisKeys = try client.command("KEYS", [.bulkString(namespaced(namespace, "*"))]).wait()
                let keys = redisKeys.array ?? []
                return keys.compactMap { $0.string?.drop(prefix: namespaced(namespace, "")) }
            }
        }
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
