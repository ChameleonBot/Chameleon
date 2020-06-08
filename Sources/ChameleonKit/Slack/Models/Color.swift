public struct Color: Codable, Equatable, RawRepresentable {
    public static var good: Color { .init(rawValue: #function) }
    public static var warning: Color { .init(rawValue: #function) }
    public static var danger: Color { .init(rawValue: #function) }

    public var rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
