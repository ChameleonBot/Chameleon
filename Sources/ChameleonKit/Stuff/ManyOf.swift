@propertyWrapper
public struct ManyOf<T: CodableElementSet>: Codable {
    public var wrappedValue: [T.Element]
    
    public init(wrappedValue: [T.Element]) {
        self.wrappedValue = wrappedValue
    }
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()

        var results: [T.Element] = []

        while !container.isAtEnd {
            let nested = try container.superDecoder()
            try results.append(nested.decodeFirst(from: T.decoders))
        }

        self.wrappedValue = results
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()

        for element in wrappedValue {
            let nested = container.superEncoder()
            try nested.encode(element, from: T.encoders)
        }
    }
}

extension ManyOf: Equatable where T: EquatableCodableElementSet {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        guard lhs.wrappedValue.count == rhs.wrappedValue.count else { return false }

        for (lhs, rhs) in zip(lhs.wrappedValue, rhs.wrappedValue) {
            if !T.isEqual(lhs, rhs) {
                return false
            }
        }

        return true
    }
}
