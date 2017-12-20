import XCTest
@testable import Common

class TimeIntervalTests: XCTestCase {
    func testValues() {
        XCTAssertEqual(5.seconds, 5)
        XCTAssertEqual(5.minutes, 300)
        XCTAssertEqual(5.hours, 18_000)
        XCTAssertEqual(5.days, 432_000)
        XCTAssertEqual(5.weeks, 3_024_000)
    }

    static var allTests = [
        ("testValues", testValues),
    ]
}
