enum EncodingRoutineError: Error { case noMatch }

public struct EncodingRoutine<T> {
    public let encode: (T, Encoder) throws -> Void

    public init(encode: @escaping (T, Encoder) throws -> Void) {
        self.encode = encode
    }
}

extension EncodingRoutine {
    public func optional() -> EncodingRoutine<T?> {
        return .init { value, encoder in
            guard let value = value else { return }
            try self.encode(value, encoder)
        }
    }
}

extension EncodingRoutine {
    public static func item<U: Encodable>(_: U.Type) -> EncodingRoutine {
        return .init { value, encoder in
            guard let encodable = value as? U else { throw EncodingRoutineError.noMatch }
            try encodable.encode(to: encoder)
        }
    }
}

extension Encoder {
    public func encode<T>(_ value: T, from routines: [EncodingRoutine<T>]) throws {
        for routine in routines {
            do {
                return try routine.encode(value, self)

            } catch EncodingRoutineError.noMatch {
                continue

            } catch let error {
                throw error
            }
        }

        throw EncodingError.invalidValue(value, .init(codingPath: codingPath, debugDescription: "None of the provided options were able to encode the data"))
    }
}
