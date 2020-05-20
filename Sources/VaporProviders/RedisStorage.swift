import ChameleonKit
import Redis

public class RedisKeyValueStorage: KeyValueStorage {
    enum Error: Swift.Error {
        case invalidValue(expected: Any.Type, value: String)
    }

    // MARK: - Private Properties
    private let factory: () throws -> RedisClient
    private let queue = DispatchQueue(label: "RedisKeyValueStorage")

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

        self.factory = {
            return try RedisDatabase(config: config).newConnection(on: worker).wait()
        }
    }

    // MARK: - Public Functions
    public func get<T: LosslessStringConvertible>(forKey key: String) throws -> T {
        return try queue.sync {
            return try factory().rawGet(key)
                .map { $0.string ?? "" }
                .map { string in
                    guard let value = T(string) else { throw Error.invalidValue(expected: T.self, value: string) }
                    return value
            }
            .wait()
        }
    }

    public func set<T: LosslessStringConvertible>(value: T, forKey key: String) throws {
        try queue.sync { try factory().rawSet(key, to: .basicString(value.description)).wait() }
    }
}
