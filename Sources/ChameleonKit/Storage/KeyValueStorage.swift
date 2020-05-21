public enum KeyValueStorageError: Error {
    case missing(key: String)
    case invalid(key: String, expected: Any.Type, found: String)
}

public protocol KeyValueStorage: AnyObject {
    func get<T: LosslessStringConvertible>(forKey key: String) throws -> T
    func set<T: LosslessStringConvertible>(value: T, forKey key: String) throws
    func remove(forKey key: String) throws
}   
