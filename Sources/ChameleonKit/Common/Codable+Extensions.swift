import Foundation

public struct Nested<T: Decodable>: Decodable {
    struct Errors: Error {
        let errors: [Error]
    }

    public let value: T

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)

        var errors: [Error] = []

        for key in container.allKeys {
            do {
                self.value = try container.decode(T.self, forKey: key)
                return
                
            } catch let error {
                errors.append(error)
            }
        }

        throw DecodingError.valueNotFound(T.self, .init(
            codingPath: container.codingPath,
            debugDescription: "Unable to decode \(T.self) from any nested objects",
            underlyingError: Errors(errors: errors)
        ))
    }
}

extension JSONDecoder {
    func decodeNested<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        return try decode(Nested<T>.self, from: data).value
    }
}
