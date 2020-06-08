import XCTest
import ChameleonKit

private protocol TestType { }

private struct TypeOne: Codable, Equatable, TestType {
    let value: Int
}
private struct TypeTwo: Codable, Equatable, TestType {
    let value: String
}

private enum TestTypes: EquatableCodableElementSet {
    typealias Element = TestType

    static var decoders: [DecodingRoutine<Element>] {
        return [.item(TypeOne.init), .item(TypeTwo.init)]
    }
    static var encoders: [EncodingRoutine<Element>] {
        return [.item(TypeOne.self), .item(TypeTwo.self)]
    }
    static func isEqual(_ lhs: Element, _ rhs: Element) -> Bool {
        switch (lhs, rhs) {
        case (let lhs as TypeOne, let rhs as TypeOne): return lhs == rhs
        case (let lhs as TypeTwo, let rhs as TypeTwo): return lhs == rhs
        default: return false
        }
    }
}

private struct Model: Codable, Equatable {
    @ManyOf<TestTypes> var value: [TestType]
}

final class ManyOfTests: XCTestCase {
    func testEncoding_One() throws {
        let model = Model(value: [TypeOne(value: 42)])
        let encoded = try String(data: JSONEncoder().encode(model), encoding: .utf8)
        let expected = #"{"value":[{"value":42}]}"#
        XCTAssertEqual(encoded, expected)
    }
    func testEncoding_Two() throws {
        let model = Model(value: [TypeTwo(value: "foo")])
        let encoded = try String(data: JSONEncoder().encode(model), encoding: .utf8)
        let expected = #"{"value":[{"value":"foo"}]}"#
        XCTAssertEqual(encoded, expected)
    }
    func testDecoding_One() throws {
        let json = #"{"value":[{"value":42}]}"#
        let decoded = try JSONDecoder().decode(Model.self, from: Data(json.utf8))
        XCTAssertEqual(decoded.value.count, 1)
        XCTAssertTrue(decoded.value[0] is TypeOne)
    }
    func testDecoding_Two() throws {
        let json = #"{"value":[{"value":"foo"}]}"#
        let decoded = try JSONDecoder().decode(Model.self, from: Data(json.utf8))
        XCTAssertEqual(decoded.value.count, 1)
        XCTAssertTrue(decoded.value[0] is TypeTwo)

    }

    func testEncoding_Empty() throws {
        let model = Model(value: [])
        let encoded = try String(data: JSONEncoder().encode(model), encoding: .utf8)
        let expected = #"{"value":[]}"#
        XCTAssertEqual(encoded, expected)
    }
    func testDecoding_Null() throws {
        let json = #"{"value":null}"#
        let decoded = try JSONDecoder().decode(Model.self, from: Data(json.utf8))
        XCTAssertEqual(decoded.value.count, 0)
    }
    func testDecoding_Empty() throws {
        let json = "{}"
        let decoded = try JSONDecoder().decode(Model.self, from: Data(json.utf8))
        XCTAssertEqual(decoded.value.count, 0)
    }

    func testEquality() throws {
        XCTAssertEqual(Model(value: [TypeOne(value: 42)]), Model(value: [TypeOne(value: 42)]))
        XCTAssertNotEqual(Model(value: [TypeOne(value: 42)]), Model(value: [TypeOne(value: 1)]))
    }
}
