
import Foundation

public enum HTTPMethod: String {
    case GET, PUT, POST, DELETE
}

public protocol HTTPServer {
    typealias RequestHandler = (_ url: URL, _ headers: [String: String], _ body: [String: Any]) throws -> HTTPServerResponse

    func start() throws

    func register(_ method: HTTPMethod, path: [String], handler: @escaping RequestHandler)
}

public extension HTTPServer {
    func register<T: AnyObject>(_ method: HTTPMethod, path: [String], target: T, _ handler: @escaping (T) -> RequestHandler) {
        register(method, path: path) { [weak target] url, headers, body in
            guard let target = target else { return HTTPResponse.ok }

            return try handler(target)(url, headers, body)
        }
    }
}
