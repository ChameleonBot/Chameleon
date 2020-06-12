public struct DebugLevel {
    let handle: (Error) throws -> Void

    public init(handle: @escaping (Error) throws -> Void) {
        self.handle = handle
    }
}

extension DebugLevel {
    public static var none: DebugLevel {
        return .init { _ in }
    }
    public static var print: DebugLevel {
        return .init { Swift.print($0) }
    }
    public static var `throw`: DebugLevel {
        return .init { throw $0 }
    }
}
