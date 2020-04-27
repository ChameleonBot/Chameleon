import Foundation

public protocol CodingStrategy {
    associatedtype Converted
    associatedtype RawValue: Codable

    static func toRaw(_ value: Converted) throws -> RawValue
    static func toValue(_ raw: RawValue) throws -> Converted
}

@propertyWrapper
public struct Convertible<T: CodingStrategy>: Codable {
    public let rawValue: T.RawValue
    public let wrappedValue: T.Converted

    public init(from decoder: Decoder) throws {
        try self.init(rawValue: T.RawValue(from: decoder))
    }
    public func encode(to encoder: Encoder) throws {
        try rawValue.encode(to: encoder)
    }

    public init(wrappedValue value: T.Converted) {
        self.wrappedValue = value
        self.rawValue = try! T.toRaw(value)
    }
    public init(rawValue: T.RawValue) throws {
        self.rawValue = rawValue
        self.wrappedValue = try T.toValue(rawValue)
    }

    public var projectedValue: T.RawValue { return rawValue }
}

extension Convertible: Equatable where T.RawValue: Equatable, T.Converted: Equatable { }
extension Convertible: Hashable where T.RawValue: Hashable, T.Converted: Hashable { }

extension Optional: CodingStrategy where Wrapped: CodingStrategy {
    public static func toRaw(_ value: Optional<Wrapped.Converted>) throws -> Optional<Wrapped.RawValue> {
        return try value.map(Wrapped.toRaw)
    }
    public static func toValue(_ raw: Optional<Wrapped.RawValue>) throws -> Optional<Wrapped.Converted> {
        return try raw.map(Wrapped.toValue)
    }
}

extension KeyedDecodingContainer {
    public func decode<T: CodingStrategy, U>(_ type: Convertible<T>.Type, forKey key: KeyedDecodingContainer.Key) throws -> Convertible<T> where T.RawValue == U? {
        guard let value = try decodeIfPresent(T.RawValue.self, forKey: key) else { return try Convertible<T>(rawValue: nil) }
        return try Convertible<T>(rawValue: value)
    }
}

extension KeyedEncodingContainer {
    public mutating func encode<T: CodingStrategy, U>(_ value: Convertible<T>, forKey key: KeyedEncodingContainer<K>.Key) throws where T.RawValue == U? {
        guard let value = value.rawValue else { return }
        try encode(value, forKey: key)
    }
}

public struct Timestamp: CodingStrategy {
    public static func toRaw(_ value: Date) throws -> TimeInterval {
        return value.timeIntervalSince1970
    }
    public static func toValue(_ raw: TimeInterval) throws -> Date {
        return Date(timeIntervalSince1970: raw)
    }
}

public struct StringTimestamp: CodingStrategy {
    public static func toRaw(_ value: Date) throws -> String {
        return "\(value.timeIntervalSince1970)"
    }
    public static func toValue(_ raw: String) throws -> Date {
        return Date(timeIntervalSince1970: TimeInterval(raw)!)
    }
}
