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
        XCTAssertClear(test)
    }

    func testMatching_ExactMatch_CaseInsensitive() throws {
        let test = try SlackBot.test()
        var count = 0

        test.bot.listen(for: .message) { bot, message in
            try message.matching("hello world") { count += 1 }
            try message.matching("HELLO WORLD") { count += 1 }

            try message.richText().matching(["hello world"]) { count += 1 }
            try message.richText().matching(["HELLO WORLD"]) { count += 1 }
        }
        try test.send(.event(.message("hello world")))
        try test.send(.event(.message("HELLO WORLD")))

        XCTAssertEqual(count, 8)
        XCTAssertClear(test)
    }

    func testMatching_InlineMatch_CaseInsensitive() throws {
        let test = try SlackBot.test()
        var count = 0

        test.bot.listen(for: .message) { bot, message in
            try message.matching("hello world") { count += 1 }
            try message.matching("HELLO WORLD") { count += 1 }

            try message.richText().matching(["hello world"]) { count += 1 }
            try message.richText().matching(["HELLO WORLD"]) { count += 1 }
        }
        try test.send(.event(.message("well hello world, how are you?")))
        try test.send(.event(.message("well HELLO WORLD, how are you?!")))

        XCTAssertEqual(count, 8)
        XCTAssertClear(test)
    }

    func testMatching_MultipleElements() throws {
        let test = try SlackBot.test()
        var count = 0

        test.bot.listen(for: .message) { bot, message in
            try message.matching("hello " && .user(bot.me)) { count += 1 }
            try message.matching("HELLO " && .user(bot.me)) { count += 1 }

            try message.richText().matching(["hello", .user(bot.me)]) { count += 1 }
            try message.richText().matching(["HELLO", .user(bot.me)]) { count += 1 }
        }
        try test.send(.event(.message([.text("hello "), .user(test.bot.me.id.rawValue)])))

        XCTAssertEqual(count, 4)
        XCTAssertClear(test)
    }
}
