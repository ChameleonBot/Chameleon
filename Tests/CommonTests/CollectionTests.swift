import XCTest
@testable import Common

class CollectionTests: XCTestCase {
    func testRandom() {
        let source = Array(0..<10)

        let result = Array(0..<10_000)
            .flatMap { _ in source.randomElement }
            .map(Set<Int>.init)

        XCTAssertTrue(result.count > 1)
    }

    func testGroup() throws {
        let source = ["Aaron", "Bob", "Brian", "Carl"]

        let result = try source.group(by: { String(try $0.first.requiredValue()) })

        let expected = [
            "A" : ["Aaron"],
            "B" : ["Bob", "Brian"],
            "C" : ["Carl"],
        ]

        for (key, value) in result {
            XCTAssertEqual(value, try expected[key].requiredValue())
        }
    }

    static var allTests = [
        ("testRandom", testRandom),
        ("testGroup", testGroup),
    ]
}
