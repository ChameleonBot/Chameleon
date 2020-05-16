import XCTest
import ChameleonKit

final class ParserTests: XCTestCase {
    func testAnyUser_WithoutName() throws {
        let input = "<@U04UAVAEB>"
        let result = try Parser<Identifier<User>>.user.parse(input[...])
        XCTAssertEqual(result.value, .init(rawValue: "U04UAVAEB"))
    }

    func testAnyUser_WithName() throws {
        let input = "<@U04UAVAEB|iankeen>"
        let result = try Parser<Identifier<User>>.user.parse(input[...])
        XCTAssertEqual(result.value, .init(rawValue: "U04UAVAEB"))
    }

    func testUser_WithoutName() throws {
        let input = "<@U04UAVAEB>"
        let result = try Parser<Identifier<User>>.user(.init(rawValue: "U04UAVAEB")).parse(input[...])
        XCTAssertEqual(result.value, .init(rawValue: "U04UAVAEB"))
    }
    func testUser_WithoutName_Fail() throws {
        let input = "<@U04ABCDEF>"
        XCTAssertThrowsError(try Parser<Identifier<User>>.user(.init(rawValue: "U04UAVAEB")).parse(input[...]))
    }

    func testUser_WithName() throws {
        let input = "<@U04UAVAEB|iankeen>"
        let result = try Parser<Identifier<User>>.user(.init(rawValue: "U04UAVAEB")).parse(input[...])
        XCTAssertEqual(result.value, .init(rawValue: "U04UAVAEB"))
    }
    func testUser_WithName_Fail() throws {
        let input = "<@U04ABCDEF|iankeen>"
        XCTAssertThrowsError(try Parser<Identifier<User>>.user(.init(rawValue: "U04UAVAEB")).parse(input[...]))
    }

    func testStart_Success() throws {
        let input = "hello <@U04ABCDEF|iankeen>"
        let parser: Parser<Identifier<User>> = ^"hello " *> .user
        let result = try parser.parse(input[...])
        XCTAssertEqual(result.value, .init(rawValue: "U04ABCDEF"))
    }
    func testStart_Fail() throws {
        let input = "well hello <@U04ABCDEF|iankeen>"
        let parser: Parser<Identifier<User>> = ^"hello " *> .user
        XCTAssertThrowsError(try parser.parse(input[...]))
    }

    func testEnd_Success() throws {
        let input = "hello <@U04ABCDEF|iankeen>"
        let parser: Parser<Identifier<User>> = "hello " *> .user^
        let result = try parser.parse(input[...])
        XCTAssertEqual(result.value, .init(rawValue: "U04ABCDEF"))
    }
    func testEnd_Fail() throws {
        let input = "hello <@U04ABCDEF|iankeen> how are you?"
        let parser: Parser<Identifier<User>> = ^"hello " *> .user^
        XCTAssertThrowsError(try parser.parse(input[...]))
    }
}
