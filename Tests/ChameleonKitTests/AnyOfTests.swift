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
    @AnyOf<TestTypes> var value: TestType
}
private struct OptionalModel: Codable, Equatable {
    @AnyOf<TestTypes?> var value: TestType?
}

final class AnyOfTests: XCTestCase {
    func testEncoding_One() throws {
        let model = Model(value: TypeOne(value: 42))
        let encoded = try String(data: JSONEncoder().encode(model), encoding: .utf8)
        let expected = """
        {"value":{"value":42}}
        """
        XCTAssertEqual(encoded, expected)
    }
    func testEncoding_Two() throws {
        let model = Model(value: TypeTwo(value: "foo"))
        let encoded = try String(data: JSONEncoder().encode(model), encoding: .utf8)
        let expected = """
        {"value":{"value":"foo"}}
        """
        XCTAssertEqual(encoded, expected)
    }
    func testDecoding_One() throws {
        let json = """
        {"value":{"value":42}}
        """
        let decoded = try JSONDecoder().decode(Model.self, from: Data(json.utf8))
        XCTAssertTrue(decoded.value is TypeOne)
    }
    func testDecoding_Two() throws {
        let json = """
        {"value":{"value":"foo"}}
        """
        let decoded = try JSONDecoder().decode(Model.self, from: Data(json.utf8))
        XCTAssertTrue(decoded.value is TypeTwo)
    }

    func testEncoding_One_Some() throws {
        let model = OptionalModel(value: TypeOne(value: 42))
        let encoded = try String(data: JSONEncoder().encode(model), encoding: .utf8)
        let expected = """
        {"value":{"value":42}}
        """
        XCTAssertEqual(encoded, expected)
    }
    func testEncoding_One_Nil() throws {
        let model = OptionalModel(value: nil)
        let encoded = try String(data: JSONEncoder().encode(model), encoding: .utf8)
        let expected = "{}"
        XCTAssertEqual(encoded, expected)
    }
    func testDecoding_One_Some() throws {
        let json = """
        {"value":{"value":42}}
        """
        let decoded = try JSONDecoder().decode(OptionalModel.self, from: Data(json.utf8))
        XCTAssertNotNil(decoded.value)
        XCTAssertTrue(decoded.value is Optional<TypeOne>)
    }
    func testDecoding_Two_Some() throws {
        let json = """
        {"value":{"value":"foo"}}
        """
        let decoded = try JSONDecoder().decode(OptionalModel.self, from: Data(json.utf8))
        XCTAssertNotNil(decoded.value)
        XCTAssertTrue(decoded.value is Optional<TypeTwo>)
    }

    func testDecoding_Null() throws {
        let json = """
        {"value":null}
        """
        let decoded = try JSONDecoder().decode(OptionalModel.self, from: Data(json.utf8))
        XCTAssertNil(decoded.value)
    }
    func testDecoding_Empty() throws {
        let json = """
        {}
        """
        let decoded = try JSONDecoder().decode(OptionalModel.self, from: Data(json.utf8))
        XCTAssertNil(decoded.value)
    }
}
