import ChameleonKit
import Foundation

public struct RichTextFixture {
    let values: () throws -> (MarkdownString, RichTextElement)

    public init(values: @escaping () throws -> (MarkdownString, RichTextElement)) {
        self.values = values
    }
}

extension RichTextFixture {
    public static func text(_ value: String) -> RichTextFixture {
        return .init { try ("\(value)", Message.Layout.RichText.Element.Text(from: .text(value))) }
    }
    public static func user(_ value: String) -> RichTextFixture {
        return .init { try ("\(Identifier<User>(rawValue: value))", Message.Layout.RichText.Element.User(from: .user(value))) }
    }

    public static func link(text: String? = nil, url: URL) -> RichTextFixture {
        let string: MarkdownString

        switch text {
        case let text?: string = "\("\(text)", url)"
        case nil: string = "\(url)"
        }

        return .init { try (string, Message.Layout.RichText.Element.Link(from: .link(text: text, url: url))) }
    }
}
