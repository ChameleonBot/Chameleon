public struct Confirmation: Codable, Equatable {
    public var title: Text.PlainText
    public var text: Text

    public var confirm: Text.PlainText
    public var deny: Text.PlainText
    public var style: Style?
}
