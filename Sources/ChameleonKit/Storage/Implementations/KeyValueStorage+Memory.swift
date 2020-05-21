public class MemoryKeyValueStorage: KeyValueStorage {
    private var data: [String: String] = [:]

    public init() { }

    public func get<T: LosslessStringConvertible>(forKey key: String) throws -> T {
        guard let string = data[key] else { throw KeyValueStorageError.missing(key: key) }
        guard let value = T(string) else { throw KeyValueStorageError.invalid(key: key, expected: T.self, found: string) }
        return value
    }
    public func set<T: LosslessStringConvertible>(value: T, forKey key: String) throws {
        data[key] = value.description
    }
    public func remove(forKey key: String) throws {
        data[key] = nil
    }
}
