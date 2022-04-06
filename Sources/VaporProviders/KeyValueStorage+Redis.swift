import ChameleonKit
import Redis
import Foundation
import NIO

public class RedisKeyValueStorage: KeyValueStorage {
    // MARK: - Private Properties
    private let factory: () throws -> RedisConnection

    // MARK: - Lifecycle
    public convenience init(hostname: String, port: Int, password: String?, database: Int?) throws {
		let config = try RedisConnection.Configuration(
			hostname: hostname,
			port: port,
			password: password,
			initialDatabase: database
		)
        self.init(config: config)
    }
    public convenience init(url: URL) throws {
        let config = try RedisConnection.Configuration(url: url)
        self.init(config: config)
    }
    private init(config: RedisConnection.Configuration) {
        let worker = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)

        var client: RedisConnection?
        let queue = DispatchQueue(label: "RedisKeyValueStorage")

        self.factory = {
            return try queue.sync {
				if client == nil || client?.isConnected == false {
					client = try RedisConnection.make(
						configuration: config,
						boundEventLoop: worker.any()
					)
					.wait()
                }
                return client!
            }
        }
    }

    // MARK: - Public Functions
    public func get<T: LosslessStringConvertible>(_: T.Type, forKey key: String) throws -> T {
        return try raw { client in
			return try client.get(.init(key))
                .flatMapThrowing { value -> String in
                    guard let string = value.string else { throw KeyValueStorageError.missing(key: key) }
                    return string
                }
                .flatMapThrowing { string in
                    guard let value = T(string) else { throw KeyValueStorageError.invalid(key: key, expected: T.self, found: string) }
                    return value
                }
                .wait()
        }
    }
    public func set<T: LosslessStringConvertible>(value: T, forKey key: String) throws {
		try raw { try $0.set(.init(key), to: value.description).wait() }
    }
    public func remove(forKey key: String) throws {
		try raw { _ = try $0.delete(.init(key)).wait() }
    }

    // MARK: - Internal
    func raw<T>(_ closure: (RedisClient) throws -> T) throws -> T {
        return try closure(factory())
    }
}
