import XCTest
import ChameleonKit
import ChameleonTestKit

final class SlackBotTests_Listening: XCTestCase {
    func testSlackEvents_CancelListening() throws {
        let test = try SlackBot.test()

        var count = 0
        test.bot.listen(for: .message) { _, _ in count += 1 }
        let listen = test.bot.listen(for: .message) { _, _ in count += 1 }

        try test.send(.event(.message("hello")))
        XCTAssertEqual(count, 2)

        count = 0
        listen.cancel()
        try test.send(.event(.message("hello")))
        XCTAssertEqual(count, 1)

        XCTAssertClear(test)
    }
}
