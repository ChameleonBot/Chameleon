
func namespaced(_ namespace: String, _ key: String) -> String {
    return "\(namespace):\(key)"
}
func execute<T>(_ closure: () throws -> T) rethrows -> T {
    do {
        return try closure()
    } catch let error {
        throw StorageError(error) ?? error
    }
}

extension StorageError {
    init?(_ error: Error) {
        switch error {
        case KeyValueStoreError.missing(let key):
            self = .missing(key: key)
        case KeyValueStoreError.invalid(let key, let expected, let found):
            self = .invalid(key: key, expected: expected, found: found)
        default:
            return nil
        }
    }
}
