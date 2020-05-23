public enum KeyValueStorageError: Error {
    case missing(key: String)
    case invalid(key: String, expected: Any.Type, found: String)
}

public protocol KeyValueStorage: AnyObject {
    func get<T: LosslessStringConvertible>(_: T.Type, forKey key: String) throws -> T
    func set<T: LosslessStringConvertible>(value: T, forKey key: String) throws
    func remove(forKey key: String) throws
}

extension KeyValueStorage {
    public func get<T: LosslessStringConvertible>(forKey key: String) throws -> T {
        return try get(T.self, forKey: key)
    }
    public func get<T: LosslessStringConvertible>(_: T.Type = T.self, forKey key: String, or value: @autoclosure() -> T) throws -> T {
        do {
            return try get(T.self, forKey: key)
        } catch KeyValueStorageError.missing {
            return value()
        }
    }
}
