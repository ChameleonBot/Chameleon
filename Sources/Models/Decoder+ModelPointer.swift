
public extension Common.Decoder {
    public func pointer<T: IDRepresentable>(at keyPath: [KeyPathComponent]) throws -> ModelPointer<T> {
        let pointerId: String = try value(at: keyPath)
        return ModelPointer(id: pointerId)
    }
    public func pointers<T: IDRepresentable>(at keyPath: [KeyPathComponent]) throws -> [ModelPointer<T>] {
        let pointerIds: [String] = try value(at: keyPath)
        return pointerIds.map(ModelPointer.init)
    }
}
