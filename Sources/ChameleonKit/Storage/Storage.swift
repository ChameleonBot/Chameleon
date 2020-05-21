public protocol Storage: class {
    func get<T: LosslessStringConvertible>(forKey key: String, from namespace: String) throws -> T
    func set<T: LosslessStringConvertible>(forKey key: String, from namespace: String, value: T) throws
    func remove(forKey key: String, from namespace: String) throws
}
