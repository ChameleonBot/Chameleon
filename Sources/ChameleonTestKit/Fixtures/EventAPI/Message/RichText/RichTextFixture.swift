import ChameleonKit

public struct RichTextFixture {
    let values: () throws -> (MarkdownString, RichTextElement)
}

extension RichTextFixture {
    public static func text(_ value: String) -> RichTextFixture {
        return .init { try ("\(value)", Message.Layout.RichText.Element.Text(from: .text(value))) }
    }
    public static func user(_ value: String) -> RichTextFixture {
        return .init { try ("\(Identifier<User>(rawValue: value))", Message.Layout.RichText.Element.User(from: .user(value))) }
    }
}
