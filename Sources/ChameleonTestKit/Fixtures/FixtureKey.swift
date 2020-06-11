import ChameleonKit

public struct FixtureKey: RawRepresentable, Hashable {
    public var rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension FixtureKey {
    public static var event: FixtureKey { .init(rawValue: #function) }
    public static var token: FixtureKey { .init(rawValue: #function) }

    public static var email: FixtureKey { .init(rawValue: #function) }
}
