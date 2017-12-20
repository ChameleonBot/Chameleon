
public extension Decoder {
    public func value<T: Decodable>(of type: T.Type = T.self, at keyPath: [KeyPathComponent]) throws -> T {
        let innerData: [String: Any] = try value(at: keyPath)
        let decoder = Decoder(data: innerData)

        return try T(decoder: decoder)
    }
    public func values<T: Decodable>(of type: T.Type = T.self, at keyPath: [KeyPathComponent]) throws -> [T] {
        let innerData: [[String: Any]] = try value(at: keyPath)

        return try innerData.map { try T(decoder: Decoder(data: $0)) }
    }
}
