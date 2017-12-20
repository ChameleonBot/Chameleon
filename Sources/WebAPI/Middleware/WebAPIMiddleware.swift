import Foundation

public struct WebAPIMiddleware: NetworkMiddleware {
    public func process(current: NetworkMiddlewareResult, request: URLRequest, response: NetworkResponse, result: @escaping (NetworkMiddlewareResult) -> Void) {

        guard !current.isFailure else { return result(current) }

        if let json = response.jsonDictionary, let error = json["error"] as? String {
            result(.fail(error: HTTPStatusCodeMiddleware.Error.clientError(
                request: request,
                code: response.response.statusCode,
                data: error
            )))

        } else {
            result(current)
        }
    }
}
