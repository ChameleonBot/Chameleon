import XCTest
@testable import Common

class DictionaryTests: XCTestCase {
    func testAppending() {
        let left = [
            "A": [1,2,3],
            "B": [3,4,5],
        ]
        let right = [
            "B": [6],
            "C": [7,8,9],
        ]

        let result = left.appending(right)

        let expected = [
            "A" : [1,2,3],
            "B" : [6],
            "C" : [7,8,9],
        ]

        for (key, value) in result {
            XCTAssertEqual(value, try expected[key].requiredValue())
        }
    }
}

extension DictionaryTests {
    func testMap() {
        let source = [
            "one": 1,
            "two": 2,
            "three": 3,
        ]

        let result = source.map { ($0.uppercased(), String($1)) }

        let expected = [
            "ONE": "1",
            "TWO": "2",
            "THREE": "3",
        ]

        for (key, value) in result {
            XCTAssertEqual(value, try expected[key].requiredValue())
        }
    }
    func testMapValues() {
        let source = [
            "one": 1,
            "two": 2,
            "three": 3,
        ]

        let result = source.mapValues { $0 + 1 }

        let expected = [
            "one": 2,
            "two": 3,
            "three": 4,
        ]

        for (key, value) in result {
            XCTAssertEqual(value, try expected[key].requiredValue())
        }
    }
    func testFlatMap() {
        let source = [
            "one": 1,
            "two": 2,
            "three": 3,
            ]

        let result: [String: String] = source.flatMap { key, value in
            guard value != 2 else { return nil }

            return (key.uppercased(), String(value))
        }

        let expected = [
            "ONE": "1",
            "THREE": "3",
        ]

        for (key, value) in result {
            XCTAssertEqual(value, try expected[key].requiredValue())
        }
    }
}

extension DictionaryTests {
    func testFilter() {
        let source = [
            "one": 1,
            "two": 2,
            "three": 3,
        ]

        let result = source.filter { $0.value != 2 }

        let expected = [
            "one": 1,
            "three": 3,
        ]

        for (key, value) in result {
            XCTAssertEqual(value, try expected[key].requiredValue())
        }
    }
}

extension DictionaryTests {
    func testMakeString() {
        let source: [String: Any] = [
            "A": 1,
            "B": [1,2],
            "C": ["D": 3],
        ]

        guard let result = source.makeString() else { return XCTFail() }

        // the order can't be determined so we cater for each..
        // curious if there is a better way?
        let expected = [
            "{\"C\":{\"D\":3},\"B\":[1,2],\"A\":1}", // cd, b, a
            "{\"C\":{\"D\":3},\"A\":1,\"B\":[1,2]}", // cd, a, b
            "{\"B\":[1,2],\"A\":1,\"C\":{\"D\":3}}", // b, a, cd
            "{\"A\":1,\"B\":[1,2],\"C\":{\"D\":3}}", // a, b, cd
            "{\"B\":[1,2],\"C\":{\"D\":3},\"A\":1}", // b, cd, a
            "{\"A\":1,\"C\":{\"D\":3},\"B\":[1,2]}", // a, cd, b
        ]

        XCTAssertNotNil(expected.first(where: { $0 == result }), "None of the expected values matched: \(result)")
    }
}

extension DictionaryTests {
    static var allTests = [
        ("testAppending", testAppending),

        ("testMap", testMap),
        ("testMapValues", testMapValues),
        ("testFlatMap", testFlatMap),

        ("testFilter", testFilter),

        ("testMakeString", testMakeString),
    ]
}
