import XCTest
import ChameleonKit
import ChameleonTestKit

final class SlackBotTests_ErrorHandling: XCTestCase {
    func testSlackBot_EventError() throws {
        let test = try SlackBot.test()

        test.bot.listen(for: .message) { bot, _ in
            try test.enqueue([.emptyJson])
            try test.bot.perform(.authDetails)
        }
        try test.send(.event(.message("")))

        XCTAssertEqual(test.errors.count, 1)

        let expected = test.errors[0].traverse(
            SlackEventError.self, SlackActionError<AuthenticationDetails>.self
        )

        switch expected {
        case DecodingError.valueNotFound?:
            XCTAssertTrue(true)

        default:
            XCTFail("Unexpected error: \(expected as Any)")
        }
    }
}

extension FixtureSource {
    static var emptyJson: FixtureSource { .init(raw: "{}") }
}
