import Foundation

public struct Option: Codable, Equatable {
    public var text: Text
    public var value: String
    public var decription: Text.PlainText?
    public var url: URL?
}
