@propertyWrapper
public struct AnyOf<T: CodableElementSet>: Codable {
    public var wrappedValue: T.Element

    public init(wrappedValue: T.Element) {
        self.wrappedValue = wrappedValue
    }
    public init(from decoder: Decoder) throws {
        self.wrappedValue = try decoder.decodeFirst(from: T.decoders)
    }
    public func encode(to encoder: Encoder) throws {
        try encoder.encode(wrappedValue, from: T.encoders)
    }
}

extension AnyOf: Equatable where T: EquatableCodableElementSet {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return T.isEqual(lhs.wrappedValue, rhs.wrappedValue)
    }
}
