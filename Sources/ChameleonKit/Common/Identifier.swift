public struct Identifier<T>: Codable, Hashable, RawRepresentable, LosslessStringConvertible {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    public init(_ description: String) {
        self.rawValue = description
    }
    public var description: String {
        return rawValue
    }
}
