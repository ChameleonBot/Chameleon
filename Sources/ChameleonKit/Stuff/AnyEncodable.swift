public struct AnyEncodable: Encodable {
    public let base: Any

    private let encode: (Encoder) throws -> Void

    public init(_ encodable: Encodable) {
        self.base = encodable
        self.encode = encodable.encode
    }
    public func encode(to encoder: Encoder) throws {
        try encode(encoder)
    }
}
