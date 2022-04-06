import ChameleonTestKit

extension FixtureSource {
    static func messageMultiContainer() throws -> FixtureSource<Any> {
        return try .init(jsonFile: "RichTextMessage_SectionAndPreformatted")
    }
}
