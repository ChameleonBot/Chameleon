import Common

public enum NetworkError: Error {
    case invalidResponse(Any?)
    case timeout
}

public enum NetworkRequestError: Error, CustomStringConvertible {
    case error(request: NetworkRequest, error: Error)

    public var description: String {
        switch self {
        case .error(let request, let error):
            return "\(String(describing: request)): \(String(describing: error))"
        }
    }
}

public protocol Network: class {
    func register(middleware: [NetworkMiddleware])

    func perform(request: NetworkRequest, middleware: [NetworkMiddleware]) throws -> NetworkResponse

    func perform(request: NetworkRequest) throws -> NetworkResponse
}

public extension Network {
    func perform(request: NetworkRequest) throws -> NetworkResponse {
        return try perform(request: request, middleware: [])
    }
}
