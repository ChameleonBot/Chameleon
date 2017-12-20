
public enum Result<T> {
    case success(T)
    case failure(Error)
}

public extension Result {
    init(_ value: T) {
        self = .success(value)
    }

    init(_ error: Error) {
        self = .failure(error)
    }

    init(_ closure: () throws -> T) {
        do { self = .success(try closure()) }
        catch let error { self = .failure(error) }
    }
}

public extension Result {
    func extract() throws -> T {
        switch self {
        case .failure(let error): throw error
        case .success(let value): return value
        }
    }
}

public extension Result {
    func map<U>(_ transform: (T) throws -> U) -> Result<U> {
        return Result<U>({ try transform(try self.extract()) })
    }

    func flatMap<U>(_ transform: (T) throws -> Result<U>) -> Result<U> {
        do {
            return try transform(try self.extract())
        } catch let error {
            return .failure(error)
        }
    }
}

public extension Result {
    func then(_ closure: (T) -> Void) -> Result<T> {
        do {
            closure(try self.extract())
            return self

        } catch let error {
            return .failure(error)
        }
    }
}
