import Foundation

public struct Button: Codable, Equatable {
    public static let type = "button"

    public var type: String
    public var text: Text.PlainText
    public var action_id: String
    public var url: URL?
    public var value: String?
    public var style: Style?
    public var confirm: Confirmation?
}
