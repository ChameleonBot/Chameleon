@propertyWrapper
public struct Indirect<T> {
    private var box: Box<T>

    public var wrappedValue: T {
        get { box.value }
        set {
            if !isKnownUniquelyReferenced(&box) {
                box = Box(box.value)
            }
            box.value = newValue
        }
    }

    public init(wrappedValue: T) {
        self.box = Box(wrappedValue)
    }
}

final class Box<T> {
    var value: T

    init(_ value: T) {
        self.value = value
    }
}

extension Indirect: Decodable where T: Decodable {
    public init(from decoder: Decoder) throws {
        self.init(wrappedValue: try T(from: decoder))
    }
}

extension Indirect: Encodable where T: Encodable {
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension KeyedDecodingContainer {
    public func decode<T: Decodable>(_ type: Indirect<T?>.Type, forKey key: KeyedDecodingContainer.Key) throws -> Indirect<T?> {
        return Indirect<T?>(wrappedValue: try decodeIfPresent(T.self, forKey: key))
    }
}

extension KeyedEncodingContainer {
    public mutating func encode<T: Encodable>(_ value: Indirect<T?>, forKey key: KeyedEncodingContainer<K>.Key) throws {
        guard let value = value.wrappedValue else { return }
        try encode(value, forKey: key)
    }
}

extension Indirect: Equatable where T: Equatable {
    public static func ==(lhs: Indirect, rhs: Indirect) -> Bool {
        return lhs.wrappedValue == rhs.wrappedValue
    }
}
