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

private struct OptionalModel: Codable, Equatable {
    private enum CodingKeys: String, NestedCodingKey {
        case value = "nested.value"
    }

    @NestedKey var value: Int?
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

    func testOptionalDecoding_Some() throws {
        let json = Data(#"{"nested":{"value":42}}"#.utf8)
        let model = try JSONDecoder().decode(OptionalModel.self, from: json)

        XCTAssertEqual(model, OptionalModel(value: 42))
    }
    func testOptionalDecoding_None_Value() throws {
        let json = Data(#"{"nested":{"value":null}}"#.utf8)
        let model = try JSONDecoder().decode(OptionalModel.self, from: json)

        XCTAssertEqual(model, OptionalModel(value: nil))
    }
    func testOptionalDecoding_None_Container() throws {
        let json = Data(#"{"nested":null}"#.utf8)
        let model = try JSONDecoder().decode(OptionalModel.self, from: json)

        XCTAssertEqual(model, OptionalModel(value: nil))
    }
}
