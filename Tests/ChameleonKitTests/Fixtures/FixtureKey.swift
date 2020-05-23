import ChameleonKit

struct FixtureKey: RawRepresentable, Hashable {
    var rawValue: String
}

extension FixtureKey {
    static var text: FixtureKey { return .init(rawValue: #function) }
    static var richTextElements: FixtureKey { return .init(rawValue: #function) }
    
    static var userId: FixtureKey { return .init(rawValue: #function) }
}
