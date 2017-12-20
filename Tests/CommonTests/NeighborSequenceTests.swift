import XCTest
@testable import Common

class NeighborSequenceTests: XCTestCase {
    func testIteration() {
        let source = Array(0..<5)

        let result = source.neighbors

        let expected: [NeighborSequence<[Int]>.Element] = [
            (previous: nil, current: 0, next: 1),
            (previous: 0, current: 1, next: 2),
            (previous: 1, current: 2, next: 3),
            (previous: 2, current: 3, next: 4),
            (previous: 3, current: 4, next: nil),
        ]

        for (a, b) in zip(result, expected) {
            XCTAssertEqual(a.previous, b.previous)
            XCTAssertEqual(a.current, b.current)
            XCTAssertEqual(a.next, b.next)
        }
    }

    static var allTests = [
        ("testIteration", testIteration),
    ]
}
