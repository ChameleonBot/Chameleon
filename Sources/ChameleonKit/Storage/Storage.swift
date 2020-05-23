public enum StorageError: Error {
    case missing(key: String)
    case invalid(key: String, expected: Any.Type, found: String)
}

public protocol Storage: AnyObject {
    func get<T: LosslessStringConvertible>(_: T.Type, forKey key: String, from namespace: String) throws -> T
    func set<T: LosslessStringConvertible>(forKey key: String, from namespace: String, value: T) throws
    func remove(forKey key: String, from namespace: String) throws
    func keys(in namespace: String) throws -> [String]
}

extension Storage {
    public func get<T: LosslessStringConvertible>(forKey key: String, from namespace: String) throws -> T {
        return try get(T.self, forKey: key, from: namespace)
    }
    public func get<T: LosslessStringConvertible>(_: T.Type = T.self, forKey key: String, from namespace: String, or value: @autoclosure() -> T) throws -> T {
        do {
            return try get(T.self, forKey: key, from: namespace)
        } catch StorageError.missing {
            return value()
        }
    }
}
