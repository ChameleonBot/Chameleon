import Foundation

public extension HTTPStatusCodeMiddleware {
    enum Error: Swift.Error {
        case clientError(request: URLRequest, code: Int, data: String?)
        case serverError(request: URLRequest, code: Int, data: String?)
    }
}

/// NetworkMiddleware to detect client and server error codes
public struct HTTPStatusCodeMiddleware: NetworkMiddleware {
    public init() { }
    
    public func process(current: NetworkMiddlewareResult, request: URLRequest, response: NetworkResponse, result: @escaping (NetworkMiddlewareResult) -> Void) {

        guard !current.isFailure else { return result(current) }

        let code = response.response.statusCode
        var next = current

        if code >= 400 && code <= 499 {
            next = .fail(error: Error.clientError(request: request, code: code, data: response.string))

        } else if code >= 500 && code <= 499 {
            next = .fail(error: Error.serverError(request: request, code: code, data: response.string))
        }
        
        result(next)
    }
}
