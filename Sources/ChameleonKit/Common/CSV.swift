@propertyWrapper
public struct CSV<T: LosslessStringConvertible>: Codable {
    public var wrappedValue: [T]

    public init(wrappedValue: [T]) {
        self.wrappedValue = wrappedValue
    }
    
    public init(from decoder: Decoder) throws {
        let value = try String(from: decoder)
        let values = value.components(separatedBy: ",")
        guard !values.isEmpty else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Data not in CSV format\n\(value)"))
        }
        wrappedValue = try values.map { value in
            guard let result = T(value) else {
                throw DecodingError.typeMismatch(T.self, .init(codingPath: decoder.codingPath, debugDescription: "Unable to convert value '\(value)'"))
            }
            return result
        }
    }
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.map(\.description).joined(separator: ",").encode(to: encoder)
    }
}
