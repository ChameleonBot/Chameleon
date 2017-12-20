
public enum KeyValueStoreError: Error, CustomStringConvertible {
    case missing(key: String)
    case invalid(key: String, expected: Any.Type, found: Any)

    public var description: String {
        switch self {
        case .missing(let key):
            return "Key not found: '\(key)'"
        case .invalid(let key, let expected, let found):
            return "Unable to convert value '\(found)' at key '\(key)' to: \(expected)"
        }
    }
}

public protocol KeyValueStore: class {

    // TODO - replace with generic subscript in Swift4 ?

    func get<T: LosslessStringConvertible>(forKey key: String) throws -> T
    func set<T: LosslessStringConvertible>(value: T, forKey key: String)
    func remove(key: String)
}

public extension KeyValueStore {
    func get<T: LosslessStringConvertible>(forKey key: String, or `default`: T) throws -> T {
        do {
            return try get(forKey: key)
        } catch KeyValueStoreError.missing {
            return `default`
        } catch let error {
            throw error
        }
    }
}
