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

extension KeyedDecodingContainer {
    public func decode<T>(_ type: AnyOf<Optional<T>>.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> AnyOf<Optional<T>> {
        if let value = try decodeIfPresent(AnyOf<T>.self, forKey: key) {
            return AnyOf(wrappedValue: value.wrappedValue)
        } else {
            return AnyOf(wrappedValue: nil)
        }
    }
}

extension KeyedEncodingContainer {
    public mutating func encode<T>(_ value: AnyOf<Optional<T>>, forKey key: KeyedEncodingContainer<K>.Key) throws {
        guard let inner = value.wrappedValue else { return }

        let unwrapped = AnyOf<T>(wrappedValue: inner)
        try encode(unwrapped, forKey: key)
    }
}
