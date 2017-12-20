import XCTest
@testable import Common

enum TestError: Error, Equatable {
    case error

    static func ==(lhs: TestError, rhs: TestError) -> Bool {
        return true
    }
}

extension Result {
    func assertFailure<T: Error>(_ error: T) where T: Equatable {
        do {
            _ = try extract()
        } catch let e as T {
            XCTAssertEqual(error, e)
        } catch {
            XCTFail()
        }
    }
}

enum CastError<T, U>: Error {
    case failed(from: T.Type, to: U.Type)
}

func cast<T, U>(_ value: T) throws -> U {
    guard let castedValue = value as? U else { throw CastError.failed(from: T.self, to: U.self) }
    return castedValue
}

func XCTAssertThrows(error: Error, from expression: @autoclosure () throws -> Any, file: StaticString = #file, line: UInt = #line) {
    do {
        _ = try expression()
        XCTFail("Expression was successful, Expected the failure: \(error)", file: file, line: line)
    } catch let e {
        XCTAssertEqual(String(describing: e), String(describing: error), file: file, line: line)
    }
}
