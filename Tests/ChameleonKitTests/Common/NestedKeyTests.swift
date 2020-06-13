import XCTest
import ChameleonKit

private struct Model: Codable, Equatable {
    private enum CodingKeys: String, NestedCodingKey {
        case first
        case second = "nested.second"
    }

    var first: Int
    @NestedKey var second: Int
}

class NestedKeyTests: XCTestCase {
    func testEncoding() throws {
        let model = Model(first: 42, second: 24)
        let data = try JSONEncoder().encode(model)
        let string = String(data: data, encoding: .utf8)

        XCTAssertEqual(string, #"{"first":42,"nested":{"second":24}}"#)
    }
    func testDecoding() throws {
        let json = Data(#"{"first":42,"nested":{"second":24}}"#.utf8)
        let model = try JSONDecoder().decode(Model.self, from: json)

        XCTAssertEqual(model, Model(first: 42, second: 24))
    }
}
