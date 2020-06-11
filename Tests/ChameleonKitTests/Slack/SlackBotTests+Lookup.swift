import XCTest
import ChameleonKit
import ChameleonTestKit

final class SlackBotTests_Lookup: XCTestCase {
    func testSlackBot_LookupUsesCache() throws {
        let test = try SlackBot.test()
        let userId = Identifier<User>(rawValue: "1")

        // We only enqueue 1 users.info response
        // if the cache is working it will only need the first response
        // subsequent lookups will come from cache
        try test.enqueue([.usersInfo(.user(id: "1", name: "Name 1"))])

        try XCTAssertEqual(test.bot.lookup(userId).name, "Name 1")
        try XCTAssertEqual(test.bot.lookup(userId).name, "Name 1")
        XCTAssertClear(test)
    }
}
