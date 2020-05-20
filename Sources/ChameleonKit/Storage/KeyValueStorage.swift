public protocol KeyValueStorage: AnyObject {
    func get<T: LosslessStringConvertible>(forKey key: String) throws -> T
    func set<T: LosslessStringConvertible>(value: T, forKey key: String) throws
}   
