public protocol CodableElementSet {
    associatedtype Element

    static var decoders: [DecodingRoutine<Element>] { get }
    static var encoders: [EncodingRoutine<Element>] { get }
}

extension Optional: CodableElementSet where Wrapped: CodableElementSet {
    public static var decoders: [DecodingRoutine<Optional<Wrapped.Element>>] {
        return Wrapped.decoders.map({ $0.optional() }) + [.default(nil)]
    }
    public static var encoders: [EncodingRoutine<Optional<Wrapped.Element>>] {
        return Wrapped.encoders.map({ $0.optional() })
    }
}

public protocol EquatableCodableElementSet: CodableElementSet {
    static func isEqual(_ lhs: Element, _ rhs: Element) -> Bool
}

extension Optional: EquatableCodableElementSet where Wrapped: EquatableCodableElementSet {
    public static func isEqual(_ lhs: Optional<Wrapped.Element>, _ rhs: Optional<Wrapped.Element>) -> Bool {
        switch (lhs, rhs) {
        case (let lhs?, let rhs?): return Wrapped.isEqual(lhs, rhs)
        default: return false
        }
    }
}
