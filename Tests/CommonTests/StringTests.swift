import XCTest
@testable import Common

class StringTests: XCTestCase {
    func testMakeDictionary() throws {
        let source = "{\"C\":{\"D\":3},\"B\":[1,2],\"A\":1}"

        let result = try source.makeDictionary().requiredValue()

        try XCTAssertEqual(cast(result["A"].requiredValue()), 1)
        try XCTAssertEqual(cast(result["B"].requiredValue()), [1,2])
        try XCTAssertEqual(cast(result["C"].requiredValue()), ["D": 3])
    }
    func testSplit() {
        let source = "foobar"

        let (a,b) = source.split(at: source.startIndex)
        XCTAssertEqual(a, "")
        XCTAssertEqual(b, "foobar")

        let (c,d) = source.split(at: source.endIndex)
        XCTAssertEqual(c, "foobar")
        XCTAssertEqual(d, "")

        let (e,f) = source.split(at: source.index(source.startIndex, offsetBy: 3))
        XCTAssertEqual(e, "foo")
        XCTAssertEqual(f, "bar")
    }
    func testRemovePrefix() {
        let source = "foo bar"

        XCTAssertEqual(source.remove(prefix: "foo", includeWhitespace: true), "bar")
        XCTAssertEqual(source.remove(prefix: "foo", includeWhitespace: false), " bar")

        XCTAssertEqual(source.remove(prefix: "bar", includeWhitespace: true), "foo bar")
        XCTAssertEqual(source.remove(prefix: "bar", includeWhitespace: false), "foo bar")
    }
    func testSubstring() {
        let source = "foobar"

        XCTAssertEqual(source.substring(to: "b"), "foo")
        XCTAssertEqual(source.substring(to: "o"), "f")
        XCTAssertEqual(source.substring(to: "z"), nil)
    }
    func testTrimming() {
        let source = "!@#foo"

        XCTAssertEqual(source.trimCharacters(in: ["!", "@", "#"]), "foo")
        XCTAssertEqual(source.trimCharacters(in: ["@", "#"]), source)
        XCTAssertEqual(source.trimCharacters(in: ["$"]), source)

        XCTAssertEqual("".trimCharacters(in: []), "")
        XCTAssertEqual("foo".trimCharacters(in: []), "foo")
        XCTAssertEqual("".trimCharacters(in: ["$"]), "")
    }
    func testSubstrings_Regex() {
        let source = "testing 123, testing 123"

        let empty: [RegexMatch] = source.substrings(matching: "")
        XCTAssertTrue(empty.isEmpty)

        let numbers: [RegexMatch] = source.substrings(matching: "\\d+")
        let expected: [RegexMatch] = [
            RegexMatch(
                range: source.index(source.startIndex, offsetBy: 8)..<source.index(source.startIndex, offsetBy: 11),
                string: "123"
            ),
            RegexMatch(
                range: source.index(source.startIndex, offsetBy: 21)..<source.index(source.startIndex, offsetBy: 24),
                string: "123"
            ),
        ]

        XCTAssertEqual(numbers.count, expected.count)
        for (a,b) in zip(numbers, expected) {
            XCTAssertEqual(a, b)
        }
    }
    func testSubstrings_Strings() {
        let source = "testing 123, testing 123"

        let empty: [String] = source.substrings(matching: "")
        XCTAssertTrue(empty.isEmpty)

        let numbers: [String] = source.substrings(matching: "\\d+")
        let expected: [String] = ["123", "123"]

        XCTAssertEqual(numbers.count, expected.count)
        for (a,b) in zip(numbers, expected) {
            XCTAssertEqual(a, b)
        }
    }

    static var allTests = [
        ("testMakeDictionary", testMakeDictionary),
        ("testSplit", testSplit),
        ("testRemovePrefix", testRemovePrefix),
        ("testSubstring", testSubstring),
        ("testTrimming", testTrimming),
        ("testSubstrings_Regex", testSubstrings_Regex),
        ("testSubstrings_Strings", testSubstrings_Strings),
    ]
}
