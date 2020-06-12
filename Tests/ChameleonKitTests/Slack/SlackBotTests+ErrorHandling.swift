import XCTest
import ChameleonKit
import ChameleonTestKit

final class SlackBotTests_ErrorHandling: XCTestCase {
    func testSlackBot_SinglePerform() throws {
        let test = try SlackBot.test()

        try test.enqueue([.emptyJson])
        _ = try? test.bot.perform(.authDetails)

        XCTAssertEqual(test.errors.count, 1)
        switch test.errors[0] {
        case DecodingError.valueNotFound?:
            XCTAssertTrue(true)
        default:
            XCTFail("Unexpected error type")
        }
    }
}

extension FixtureSource {
    static var emptyJson: FixtureSource { .init(raw: "{}") }
}
