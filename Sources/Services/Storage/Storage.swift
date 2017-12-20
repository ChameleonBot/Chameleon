
public enum StorageError: Error, CustomStringConvertible {
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

//TODO : I expect the api for this to change into something nicer which accepts a full 'model' that can be serialized rather than a key/value based system
//       This is just this way for now so the transition from legacy Chameleon is easier

public protocol Storage: class {

    // TODO - replace with generic subscript in Swift4 ?

    func get<T: LosslessStringConvertible>(key: String, from namespace: String) throws -> T
    func set<T: LosslessStringConvertible>(value: T, forKey key: String, in namespace: String)
    func remove(key: String, from namespace: String)
    func keys(in namespace: String) throws -> [String]

}

public extension Storage {
    func get<T: LosslessStringConvertible>(key: String, from namespace: String, or `default`: T) throws -> T {
        do {
            return try get(key: key, from: namespace)
        } catch StorageError.missing {
            return `default`
        } catch let error {
            throw error
        }
    }
}
