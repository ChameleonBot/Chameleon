import XCTest
import ChameleonKit
import ChameleonTestKit

final class ElementMatchingTests: XCTestCase {
    func testAnyUser() throws {
        let message = try Message(from: .message([.text("hello "), .user("user")]))

        var user: Identifier<User>?
        try message.richText().matching(["hello", .user]) { user = $0 }

        XCTAssertEqual(user, .init(rawValue: "user"))
    }
    func testSpecificUser_Match() throws {
        let message = try Message(from: .message([.text("hello "), .user("user")]))

        var user: Identifier<User>?
        try message.richText().matching(["hello", .user(.init(rawValue: "user"))]) { user = $0 }

        XCTAssertEqual(user, .init(rawValue: "user"))
    }
    func testSpecificUser_Miss() throws {
        let message = try Message(from: .message([.text("hello "), .user("other_user")]))

        var user: Identifier<User>?
        try message.richText().matching(["hello", .user(.init(rawValue: "user"))]) { user = $0 }

        XCTAssertNil(user)
    }

    func testStartOfMessage_Match() throws {
        let message = try Message(from: .message([.user("user"), .text(" how are you?")]))

        var user: Identifier<User>?
        try message.richText().matching([^.user, "how are you?"]) { user = $0 }

        XCTAssertEqual(user, .init(rawValue: "user"))
    }
    func testStartOfMessage_Miss() throws {
        let message = try Message(from: .message([.text("hey "), .user("user"), .text(" how are you?")]))

        var user: Identifier<User>?
        try message.richText().matching([^.user, "how are you?"]) { user = $0 }

        XCTAssertNil(user)
    }

    func testEndOfMessage_Match() throws {
        let message = try Message(from: .message([.text("hey "), .user("user")]))

        var user: Identifier<User>?
        try message.richText().matching(["hey", .user^]) { user = $0 }

        XCTAssertEqual(user, .init(rawValue: "user"))
    }
    func testEndOfMessage_Miss() throws {
        let message = try Message(from: .message([.text("hey "), .user("user"), .text(" how are you?")]))

        var user: Identifier<User>?
        try message.richText().matching(["hey ", .user^]) { user = $0 }

        XCTAssertNil(user)
    }

    func testMultipleValues_TooManyMatchedValues_Fails() throws {
        let message = try Message(from: .message([.text("hello "), .user("user")]))

        do {
            try message.richText().matching(["hello", .user]) { (a: Identifier<User>, b: Identifier<User>) in
                XCTFail("Unexpected success")
            }
        } catch let error as ElementMatcher.Error {
            XCTAssertEqual(error, .typeMismatch(expected: Identifier<User>.self, value: nil))
        } catch {
            XCTFail("Unexpected error")
        }
    }
    func testMultipleValues_MatchedValueMismatch_Fails() throws {
        let message = try Message(from: .message([.text("hello "), .user("user")]))

        do {
            try message.richText().matching(["hello", .user]) { (a: String) in
                XCTFail("Unexpected success")
            }
        } catch let error as ElementMatcher.Error {
            XCTAssertEqual(error, .typeMismatch(expected: String.self, value: Identifier<User>(rawValue: "user")))
        } catch {
            XCTFail("Unexpected error")
        }
    }

    func testMultiplePatterns_RecurringPattern_Match() throws {
        let message = try Message(from: .message([.text("hello "), .user("user1"), .text(" hello "), .user("user2")]))

        var users: [Identifier<User>]?
        try message.richText().matchingAll([ElementMatcher.contains("hello"), .user]) { users = $0 }
        XCTAssertEqual(users, [
            .init(rawValue: "user1"),
            .init(rawValue: "user2"),
        ])
    }

    func testMultiplePatterns_ContainingMissAndMatch_AfterInitialMiss_StillMatches() throws {
        let message = try Message(from: .message([.user("user1"), .text(" hello "), .user("user2"), .text(" hi ")]))

        var users: [Identifier<User>]?
        try message.richText().matchingAll([.user, "hi"]) { users = $0 }
        XCTAssertEqual(users, [.init(rawValue: "user2")])
    }
}

extension ElementMatcher.Error: Equatable {
    public static func ==(lhs: ElementMatcher.Error, rhs: ElementMatcher.Error) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}
