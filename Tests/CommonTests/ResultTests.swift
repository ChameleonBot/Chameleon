import XCTest
@testable import Common

class ResultTests: XCTestCase {
    func testResult_InitValue() throws {
        let result = Result<Int>(42)
        try XCTAssertEqual(result.extract(), 42)
    }
    func testResult_InitError() {
        let result = Result<Int>(TestError.error)
        result.assertFailure(TestError.error)
    }
    func testResult_InitClosure_Value() throws {
        let result = Result<Int>({ 42 })
        try XCTAssertEqual(result.extract(), 42)
    }
    func testResult_InitClosure_Error() {
        let result = Result<Int>({ throw TestError.error })
        result.assertFailure(TestError.error)
    }

    func testResult_Map_Value() throws {
        let result = Result<Int>(42).map { String($0 * 2) }
        try XCTAssertEqual(result.extract(), "84")
    }
    func testResult_Map_Throws() throws {
        let result = Result<Int>(42)
        try XCTAssertEqual(result.extract(), 42)

        let map = result.map { _ in throw TestError.error }
        map.assertFailure(TestError.error)
    }
    func testResult_Map_AlreadyFailed() {
        let result = Result<Int>({ throw TestError.error })
        result.assertFailure(TestError.error)

        let map = result.map { $0 + 1 }
        map.assertFailure(TestError.error)
    }

    func testResult_FlatMap_Value() throws {
        let result = Result<Int>(42)
        try XCTAssertEqual(result.extract(), 42)

        let flatMap = result.flatMap { .success(String($0 * 2)) }
        try XCTAssertEqual(flatMap.extract(), "84")
    }
    func testResult_FlatMap_Throws() throws {
        let result = Result<Int>(42)
        try XCTAssertEqual(result.extract(), 42)

        let flatMap = result.flatMap { _ -> Result<String> in throw TestError.error }
        flatMap.assertFailure(TestError.error)
    }
    func testResult_FlatMap_AlreadyFailed() {
        let result = Result<Int>({ throw TestError.error })
        result.assertFailure(TestError.error)

        let flatMap = result.flatMap { .success(String($0 * 2)) }
        flatMap.assertFailure(TestError.error)
    }
}

extension ResultTests {
    static let allTests = [
        ("testResult_InitValue", testResult_InitValue),
        ("testResult_InitError", testResult_InitError),
        ("testResult_InitClosure_Value", testResult_InitClosure_Value),
        ("testResult_InitClosure_Error", testResult_InitClosure_Error),

        ("testResult_Map_Value", testResult_Map_Value),
        ("testResult_Map_Throws", testResult_Map_Throws),
        ("testResult_Map_AlreadyFailed", testResult_Map_AlreadyFailed),

        ("testResult_FlatMap_Value", testResult_FlatMap_Value),
        ("testResult_FlatMap_Throws", testResult_FlatMap_Throws),
        ("testResult_FlatMap_AlreadyFailed", testResult_FlatMap_AlreadyFailed),
    ]
}
