import Foundation

public final class RetryMiddleware: NetworkMiddleware {
    private var attempts = 0
    private let maxRetries: Int

    public init(maxRetries: Int) {
        self.maxRetries = maxRetries
    }

    public func process(current: NetworkMiddlewareResult, request: URLRequest, response: NetworkResponse, result: @escaping (NetworkMiddlewareResult) -> Void) {
        switch current {
        case .fail(let error) where attempts < maxRetries:
            switch error {
            case NetworkError.timeout:
                attempts += 1
                return result(.retry)

            default:
                break
            }

        default:
            break
        }

        result(current)
    }
}
