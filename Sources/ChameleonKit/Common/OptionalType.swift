public protocol OptionalType: ExpressibleByNilLiteral {
    associatedtype WrappedType

    var wrapped: WrappedType? { get }

    init(_ value: WrappedType)
}

extension Optional: OptionalType {
    public var wrapped: Wrapped? { return self }
}
