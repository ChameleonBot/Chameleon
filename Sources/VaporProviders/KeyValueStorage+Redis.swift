import ChameleonKit
import Redis

public class RedisKeyValueStorage: KeyValueStorage {
    // MARK: - Private Properties
    private let factory: () throws -> RedisClient

    // MARK: - Lifecycle
    public convenience init(hostname: String, port: Int, password: String?, database: Int?) {
        var config = RedisClientConfig()
        config.hostname = hostname
        config.port = port
        config.password = password
        config.database = database
        self.init(config: config)
    }
    public convenience init(url: URL) {
        let config = RedisClientConfig(url: url)
        self.init(config: config)
    }
    private init(config: RedisClientConfig) {
        let worker = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)

        var client: RedisClient?
        let queue = DispatchQueue(label: "RedisKeyValueStorage")

        self.factory = {
            return try queue.sync {
                if client == nil || client?.isClosed == true {
                    client = try RedisDatabase(config: config).newConnection(on: worker).wait()
                }
                return client!
            }
        }
    }

    // MARK: - Public Functions
    public func get<T: LosslessStringConvertible>(_: T.Type, forKey key: String) throws -> T {
        return try raw { client in
            return try client.rawGet(key)
                .map { value -> String in
                    guard let string = value.string else { throw KeyValueStorageError.missing(key: key) }
                    return string
                }
                .map { string in
                    guard let value = T(string) else { throw KeyValueStorageError.invalid(key: key, expected: T.self, found: string) }
                    return value
                }
                .wait()
        }
    }
    public func set<T: LosslessStringConvertible>(value: T, forKey key: String) throws {
        try raw { try $0.rawSet(key, to: .bulkString(value.description)).wait() }
    }
    public func remove(forKey key: String) throws {
        try raw { try $0.delete(key).wait() }
    }

    // MARK: - Internal
    func raw<T>(_ closure: (RedisClient) throws -> T) throws -> T {
        return try closure(factory())
    }
}
