import XCTest
import ChameleonKit
import ChameleonTestKit

final class SlackBotTests: XCTestCase {
    func testSlackEvents_Message() throws {
        let test = try SlackBot.test()

        var message: Message?
        test.bot.listen(for: .message) { message = $1 }
        try test.send(.event(.message("hello world")))

        XCTAssertEqual(message?.text, "hello world")
    }

    func testParserMatching_ExactMatch_CaseInsensitive() throws {
        let test = try SlackBot.test()
        var count = 0

        test.bot.listen(for: .message) { bot, message in
            try message.matching("hello world") { count += 1 }
            try message.matching("HELLO WORLD") { count += 1 }
        }
        try test.send(.event(.message("hello world")))
        try test.send(.event(.message("HELLO WORLD")))

        XCTAssertEqual(count, 4)
    }

    func testBlockElementMatching_ExactMatch_CaseInsensitive() throws {
        let test = try SlackBot.test()
        var count = 0

        test.bot.listen(for: .message) { bot, message in
            try message.matching("hello world") { count += 1 }
            try message.matching("HELLO WORLD") { count += 1 }

            try message.richText().matching(["hello world"]) { count += 1 }
            try message.richText().matching(["HELLO WORLD"]) { count += 1 }
        }
        try test.send(.event(.message([.text("hello world")])))
        try test.send(.event(.message([.text("HELLO WORLD")])))

        XCTAssertEqual(count, 8)
    }
}
