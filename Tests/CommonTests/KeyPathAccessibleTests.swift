import XCTest
@testable import Common

class KeyPathAccessibleTests: XCTestCase {
    func testArray_Success() throws {
        try XCTAssertEqual([1,2,3].value(at: 1), 2)
        try XCTAssertEqual([[1,2], [3, 4]].path(at: 1).value(at: 1), 4)
    }
    func testDictionary_Success() throws {
        let source: [String: Any] = [
            "A": 1,
            "B": [2,3],
            "C": ["A": [4, 5]],
        ]

        try XCTAssertEqual(source.value(at: "A"), 1)
        try XCTAssertEqual(source.path(at: "B").value(at: 0), 2)
        try XCTAssertEqual(source.path(at: "C").path(at: "A").value(at: 0), 4)
    }
}

extension KeyPathAccessibleTests {
    func testArray_Failure() {
        let source = [1,2,3,4]

        XCTAssertThrows(
            error: KeyPathError.invalid(key: ["foo" as KeyPathComponent]),
            from: try source.value(at: "foo")
        )
        XCTAssertThrows(
            error: KeyPathError.missing(key: [5 as KeyPathComponent]),
            from: try source.value(at: 5)
        )
        XCTAssertThrows(
            error: KeyPathError.mismatch(key: [0], expected: String.self, found: Int.self),
            from: try source.value(at: 0) as String
        )
    }
    func testDictionary_Failure() {
        let source: [String: Any] = ["A": 1]

        XCTAssertThrows(
            error: KeyPathError.invalid(key: [0 as KeyPathComponent]),
            from: try source.value(at: 0)
        )
        XCTAssertThrows(
            error: KeyPathError.missing(key: ["foo" as KeyPathComponent]),
            from: try source.value(at: "foo")
        )
        XCTAssertThrows(
            error: KeyPathError.mismatch(key: ["A"], expected: String.self, found: Any.self),
            from: try source.value(at: "A") as String
        )
    }
}

extension KeyPathAccessibleTests {
    static var allTests = [
        ("testArray_Success", testArray_Success),
        ("testDictionary_Success", testDictionary_Success),

        ("testArray_Failure", testArray_Failure),
        ("testDictionary_Failure", testDictionary_Failure),
    ]
}
