import Foundation

/// The result of the an active middleware process
///
/// - next: The middleware was successful, proceed to the next
/// - retry: The middleware requires that the network request be retried
/// - fail: The middleware failed with the specified error
public enum NetworkMiddlewareResult {
    case next(data: Data?)
    case retry
    case fail(error: Error)
}

public extension NetworkMiddlewareResult {
    var isFailure: Bool {
        switch self {
        case .fail: return true
        default: return false
        }
    }
}

/// Represents a single middleware
public protocol NetworkMiddleware {
    /// Process a NetworkResponse
    ///
    /// - Parameters:
    ///   - current: The current result of the network requests and any previous middleware
    ///   - request: The original `URLRequest`
    ///   - response: The received `NetworkResponse`
    ///   - result: A closure that must be called with the result of this middleware
    ///
    /// - Note: not calling `result` will cause the processing to stall
    func process(
        current: NetworkMiddlewareResult,
        request: URLRequest,
        response: NetworkResponse,
        result: @escaping (NetworkMiddlewareResult) -> Void
    )
}
