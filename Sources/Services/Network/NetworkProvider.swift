import Foundation
import Common
import Dispatch

public class NetworkProvider: Network {
    // MARK: - Private Properties
    fileprivate let session: URLSession
    fileprivate var middleware: [NetworkMiddleware] = []

    // MARK: - Lifecycle
    public init(session: URLSession = URLSession(configuration: .default)) { //TODO at the time of writing `URLSession.shared` is `NSUnimplemented()`
        self.session = session
    }

    // MARK: - Public
    public func register(middleware: [NetworkMiddleware]) {
        self.middleware.append(contentsOf: middleware)
    }
    public func perform(request: NetworkRequest, middleware: [NetworkMiddleware]) throws -> NetworkResponse {
        switch execute(request: request, middleware: middleware) {
        case .success(let value):
            return value
        case .failure(let error):
            throw NetworkRequestError.error(request: request, error: error)
        }
    }
}

// MARK: - Execution
private extension NetworkProvider {
    func execute(request: NetworkRequest, middleware: [NetworkMiddleware]) -> Result<NetworkResponse> {
        do {
            let urlRequest = try request.buildURLRequest()

            var finalResult: Result<NetworkResponse> = .failure(NetworkError.invalidResponse(nil))

            let group = DispatchGroup()

            let task = session.dataTask(
                with: urlRequest,
                completionHandler: { data, response, error in
                    let initialState: NetworkMiddlewareResult

                    if let error = error { initialState = .fail(error: error) }
                    else { initialState = .next(data: data) }

                    //make sure this was a HTTP request
                    guard let urlResponse = response as? HTTPURLResponse else {
                        finalResult = .failure(NetworkError.invalidResponse(response))
                        return group.leave()
                    }

                    let networkResponse = NetworkResponse(response: urlResponse, data: data)

                    let combinedMiddleware = middleware + self.middleware

                    combinedMiddleware.handle(
                        startingWith: initialState,
                        request: urlRequest,
                        response: networkResponse,
                        complete: { result in
                            switch result {
                            case .next(let data):
                                finalResult = .success(NetworkResponse(response: urlResponse, data: data))

                            case .fail(let error):
                                finalResult = .failure(error)

                            case .retry:
                                finalResult = self.execute(
                                    request: request,
                                    middleware: middleware
                                )
                            }

                            group.leave()
                    }
                    )
            }
            )

            group.enter()

            task.resume()

            switch group.wait(wallTimeout: .now() + 30) {
            case .success:
                return finalResult
            case .timedOut:
                return .failure(NetworkError.timeout)
            }

        } catch let error {
            return .failure(error)
        }
    }
}

// MARK: - Middleware
public extension Array where Element == NetworkMiddleware {
    func handle(
        startingWith result: NetworkMiddlewareResult,
        request: URLRequest,
        response: NetworkResponse,
        complete: @escaping (NetworkMiddlewareResult) -> Void
        )
    {
        guard !isEmpty else { return complete(result) }

        let active = self[0]
        let remaining = Array(dropFirst())

        func next(newResponse: NetworkResponse) {
            active.process(current: result, request: request, response: newResponse) { result in
                remaining.handle(
                    startingWith: result,
                    request: request,
                    response: response,
                    complete: complete
                )
            }
        }

        switch result {
        case .retry:
            complete(result)
            
        case .next(let data):
            let updatedResponse = NetworkResponse(response: response.response, data: data)
            next(newResponse: updatedResponse)
            
        case .fail:
            next(newResponse: response)
        }
    }
}
