import XCTest
import ChameleonKit

private struct Model: Codable, Equatable {
    let value: Int
}

class AnyEncodableTests: XCTestCase {
    func testEncoding() throws {
        let encodable = AnyEncodable(Model(value: 42))
        let result = try String(data: JSONEncoder().encode(encodable), encoding: .utf8)
        XCTAssertEqual(result, #"{"value":42}"#)
    }
}
