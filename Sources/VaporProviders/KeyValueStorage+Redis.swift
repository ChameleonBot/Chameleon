import ChameleonKit
import Redis

public class RedisKeyValueStorage: KeyValueStorage {
    enum Error: Swift.Error {
        case invalidValue(expected: Any.Type, value: String)
    }

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
                .map { $0.string ?? "" }
                .map { string in
                    guard let value = T(string) else { throw Error.invalidValue(expected: T.self, value: string) }
                    return value
            }
            .wait()
        }
    }
    public func set<T: LosslessStringConvertible>(value: T, forKey key: String) throws {
        try raw { try $0.rawSet(key, to: .basicString(value.description)).wait() }
    }
    public func remove(forKey key: String) throws {
        try raw { try $0.delete(key).wait() }
    }

    // MARK: - Internal
    func raw<T>(_ closure: (RedisClient) throws -> T) throws -> T {
        return try closure(factory())
    }
}
