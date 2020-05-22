public enum KeyValueStorageError: Error {
    case missing(key: String)
    case invalid(key: String, expected: Any.Type, found: String)
}

public protocol KeyValueStorage: AnyObject {
    func get<T: LosslessStringConvertible>(forKey key: String) throws -> T
    func set<T: LosslessStringConvertible>(value: T, forKey key: String) throws
    func remove(forKey key: String) throws
}

extension KeyValueStorage {
    public func get<T: LosslessStringConvertible>(forKey key: String, or value: @autoclosure() -> T) throws -> T {
        do {
            return try get(forKey: key)
        } catch KeyValueStorageError.missing {
            return value()
        }
    }
}
