import Redis
import Foundation

extension NSLock {
    func synchronized<T>(_ closure: () throws -> T) rethrows -> T {
        self.lock()
        defer { self.unlock() }
        return try closure()
    }
}

public final class RedisKeyValueStore: KeyValueStore {
    typealias ClientFactory = () throws -> Redis.TCPClient
    let factory: ClientFactory
    private let lock = NSLock()

    public init(hostname: String, port: UInt16, password: String? = nil, database: String? = nil) {
        self.factory = {
            let client = try Client(
                hostname: hostname,
                port: port,
                password: password
            )

            if let database = database {
                try client.command(try Command("select"), [database.description])
            }

            return client
        }
    }
    public convenience init(url: String) {
        guard
            let components = URLComponents(string: url),
            let host = components.host,
            let port = components.port
            else { fatalError("Invalid URL supplied") }

        let database = (components.path.isEmpty ? nil : components.path)

        self.init(hostname: host, port: UInt16(port), password: components.password, database: database)
    }

    public func get<T: LosslessStringConvertible>(forKey key: String) throws -> T {
        return try lock.synchronized {
            guard let string = try factory()
                .command(.get, [key])?
                .string
                else { throw KeyValueStoreError.missing(key: key) }

            guard let value = T(string)
                else { throw KeyValueStoreError.invalid(key: key, expected: T.self, found: string) }
            
            return value
        }
    }
    public func set<T: LosslessStringConvertible>(value: T, forKey key: String) {
        lock.synchronized {
            _ = try? factory().command(.set, [key, value.description])
        }
    }
    public func remove(key: String) {
        lock.synchronized {
            _ = try? factory().command(.delete, [key])
        }
    }
}
