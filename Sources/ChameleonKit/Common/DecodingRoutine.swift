enum DecodingRoutineError: Error { case noMatch }

public struct DecodingRoutine<T> {
    public let decode: (Decoder) throws -> T

    public init(decode: @escaping (Decoder) throws -> T) {
        self.decode = decode
    }
}

extension DecodingRoutine {
    public func optional() -> DecodingRoutine<T?> {
        return .init { try self.decode($0) }
    }
}

extension DecodingRoutine {
    public static func `default`(_ value: @autoclosure @escaping () throws -> T) -> DecodingRoutine {
        return .init { _ in try value() }
    }
}

extension DecodingRoutine {
    public static func item(_ factory: @escaping (Decoder) throws -> T) -> DecodingRoutine {
        return .init { decoder in
            guard let value = try? factory(decoder) else { throw DecodingRoutineError.noMatch }
            return value
        }
    }
}

extension DecodingRoutine {
    public static func item<Key: Decodable & Equatable>(_ factory: @escaping (Decoder) throws -> T, when key: String, equals value: Key) -> DecodingRoutine {
        return .init { decoder in
            guard
                let keyContainer = try? decoder.container(keyedBy: AnyCodingKey.self),
                let key = try? keyContainer.decode(Key.self, forKey: AnyCodingKey(key)),
                key == value
                else { throw DecodingRoutineError.noMatch }

            return try factory(decoder)
        }
    }
}

extension DecodingRoutine {
    public static func `case`<Case: Decodable>(_ function: @escaping (Case) -> T) -> DecodingRoutine {
        return .init { decoder in
            guard let value = try? Case(from: decoder) else { throw DecodingRoutineError.noMatch }
            return function(value)
        }
    }
}
extension DecodingRoutine {
    public static func `case`<Key: Decodable & Equatable, Case: Decodable>(_ function: @escaping (Case) -> T, when key: String, equals value: Key) -> DecodingRoutine {
        return .init { decoder in
            guard
                let keyContainer = try? decoder.container(keyedBy: AnyCodingKey.self),
                let key = try? keyContainer.decode(Key.self, forKey: AnyCodingKey(key)),
                key == value
                else { throw DecodingRoutineError.noMatch }

            return try function(Case(from: decoder))
        }
    }
}

extension Decoder {
    public func decodeFirst<T>(from routines: [DecodingRoutine<T>]) throws -> T {
        for routine in routines {
            do {
                return try routine.decode(self)

            } catch DecodingRoutineError.noMatch {
                continue

            } catch let error {
                throw error
            }
        }

        throw DecodingError.typeMismatch(T.self, .init(codingPath: codingPath, debugDescription: "None of the provided options were able to decode the data"))
    }
}
