import ChameleonKit
import Foundation

extension FixtureSource {
    private struct Elements: Encodable {
        @ManyOf<RichTextElements> public var elements: [RichTextElement]
    }

    public static func message(text: String) throws -> FixtureSource<SlackReceiver, Message> {
        return try message(text: text, elements: [])
    }
    public static func message(elements: [RichTextElement]) throws -> FixtureSource<SlackReceiver, Message> {
        return try message(text: "", elements: elements)
    }
    public static func message(text: String, elements: [RichTextElement]) throws -> FixtureSource<SlackReceiver, Message> {
        let richTextElements = try JSONEncoder().encode(EncodeMany<RichTextElements>(values: elements))

        return try .init(jsonFile: "Message_RichTextElements", map: [
            .text: text,
            .richTextElements: String(data: richTextElements, encoding: .utf8)!
        ])
    }
}
