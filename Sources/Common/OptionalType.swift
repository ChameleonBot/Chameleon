
public protocol OptionalType {
    associatedtype WrappedType

    var value: WrappedType? { get }
}

extension Optional: OptionalType {
    public typealias WrappedType = Wrapped

    public var value: WrappedType? { return self }
}

public enum OptionalError: Error, CustomStringConvertible {
     case requiredValue

    public var description: String {
        switch self {
        case .requiredValue: return "Required value not present"
        }
    }
}

public extension OptionalType {
    func requiredValue() throws -> WrappedType {
        guard let value = value else { throw OptionalError.requiredValue }

        return value
    }
}
