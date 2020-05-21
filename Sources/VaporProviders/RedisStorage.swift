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
    public func get<T: LosslessStringConvertible>(forKey key: String, from namespace: String) throws -> T {
        return try keyValueStore.get(forKey: namespaced(namespace, key))
    }
    public func set<T: LosslessStringConvertible>(forKey key: String, from namespace: String, value: T) throws {
        try keyValueStore.set(value: value, forKey: namespaced(namespace, key))
    }
    public func remove(forKey key: String, from namespace: String) throws {
        try keyValueStore.remove(forKey: namespaced(namespace, key))
    }
    public func keys(in namespace: String) throws -> [String] {
        return try keyValueStore.raw { client in
            let keys = try client.command("KEYS", [.basicString(namespaced(namespace, "*"))]).wait().array ?? []
            return keys.compactMap { $0.string?.drop(prefix: namespaced(namespace, "")) }
        }
    }

    // MARK: - Private Functions
    private func namespaced(_ namespace: String, _ key: String) -> String {
        return "\(namespace):\(key)"
    }
}

extension String {
    func drop(prefix: String) -> String {
        var start = startIndex

        for (char, index) in zip(prefix, indices) {
            guard self[index] == char else { return self }
            start = index
        }

        return start == startIndex ? self : String(self[index(after: start)...])
    }
}
