public struct Style: Codable, Equatable, RawRepresentable {
    public static var primary: Style { .init(rawValue: #function) }
    public static var danger: Style { .init(rawValue: #function) }

    public var rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
