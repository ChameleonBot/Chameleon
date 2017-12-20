
public protocol Encodable {
    func encode() -> [String: Any?]
}

public extension Dictionary where Value: OptionalType {
    func strippingNils() -> [Key: Value.WrappedType] {
        var result: [Key: Value.WrappedType] = [:]
        for (key, value) in self where value.value != nil {
            result[key] = value.value!
        }
        return result
    }
}
