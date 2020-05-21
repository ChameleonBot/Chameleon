public enum StorageError: Error {
    case missing(key: String)
    case invalid(key: String, expected: Any.Type, found: String)
}

public protocol Storage: AnyObject {
    func get<T: LosslessStringConvertible>(forKey key: String, from namespace: String) throws -> T
    func set<T: LosslessStringConvertible>(forKey key: String, from namespace: String, value: T) throws
    func remove(forKey key: String, from namespace: String) throws
}

extension Storage {
    public func get<T: LosslessStringConvertible>(forKey key: String, from namespace: String, or value: @autoclosure() -> T) -> T {
        return (try? get(forKey: key, from: namespace)) ?? value()
    }
}
