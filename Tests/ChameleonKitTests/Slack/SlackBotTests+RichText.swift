import XCTest
import ChameleonKit
import ChameleonTestKit

final class SlackBotTests_RichText: XCTestCase {
    func testSlackBot_RichTextUsesSectionOnlyByDefault() throws {
        let test = try SlackBot.test()

        test.bot.listen(for: .message) { (bot, message) in
            let allText = message.richText(.all).compactMap({ $0 as? Message.Layout.RichText.Element.Text }).map(\.text)
            let allLinks = message.richText(.all).compactMap({ $0 as? Message.Layout.RichText.Element.Link }).map(\.url.absoluteString)
            XCTAssertEqual(allText.sorted(), ["foobar ", "hello world "])
            XCTAssertEqual(allLinks.sorted(), ["http://www.apple.com", "http://www.google.com"])

            let sectionText = message.richText(.sectionOnly).compactMap({ $0 as? Message.Layout.RichText.Element.Text }).map(\.text)
            let sectionLinks = message.richText(.sectionOnly).compactMap({ $0 as? Message.Layout.RichText.Element.Link }).map(\.url.absoluteString)
            XCTAssertEqual(sectionText.sorted(), ["foobar "])
            XCTAssertEqual(sectionLinks.sorted(), ["http://www.apple.com"])
        }
        
        try test.send(.event(.messageMultiContainer()))

        XCTAssertClear(test)
    }
}
