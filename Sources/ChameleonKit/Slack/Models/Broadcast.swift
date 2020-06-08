import Foundation

public struct Broadcast: Codable, Equatable, RawRepresentable {
    public static var here: Broadcast { .init(rawValue: #function) }
    public static var channel: Broadcast { .init(rawValue: #function) }
    public static var everyone: Broadcast { .init(rawValue: #function) }

    public var rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
