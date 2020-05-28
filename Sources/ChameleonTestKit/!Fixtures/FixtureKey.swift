import ChameleonKit

public struct FixtureKey: RawRepresentable, Hashable {
    public var rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension FixtureKey {
    public static var text: FixtureKey { return .init(rawValue: #function) }
    public static var richTextElements: FixtureKey { return .init(rawValue: #function) }
    public static var userId: FixtureKey { return .init(rawValue: #function) }
    public static var event: FixtureKey { return .init(rawValue: #function) }
    public static var token: FixtureKey { return .init(rawValue: #function) }
}
