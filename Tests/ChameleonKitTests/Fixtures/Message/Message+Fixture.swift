import ChameleonKit
import Foundation

extension FixtureSource where T == Message {
    private struct Elements: Encodable {
        @ManyOf<RichTextElements> public var elements: [RichTextElement]
    }

    static func richText(text: String, elements: [RichTextElement]) throws -> FixtureSource {
        let richTextElements = try JSONEncoder().encode(EncodeMany<RichTextElements>(values: elements))

        return try .init(json: "Message_RichTextElements", map: [
            .text: text,
            .richTextElements: String(data: richTextElements, encoding: .utf8)!
        ])
    }
}
