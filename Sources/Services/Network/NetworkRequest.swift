import Foundation

// MARK: - Errors
public extension NetworkRequest {
    enum Error: Swift.Error {
        case invalidURL(String)
    }
}

// MARK: - HTTP Methods
public extension NetworkRequest {
    enum Method: String {
        case GET, PUT, PATCH, POST, DELETE
    }
}

// MARK: - NetworkRequest
public struct NetworkRequest {
    // MARK: - Properties
    public var method: Method
    public var url: String
    public var headers: [String: LosslessStringConvertible]
    public var body: DataRepresentable?

    // MARK: - Lifecycle
    public init(method: Method, url: String, headers: [String: LosslessStringConvertible] = [:], body: DataRepresentable? = nil) {
        self.method = method
        self.url = url
        self.headers = headers
        self.body = body
    }

    // MARK: - Public
    public func buildURLRequest() throws -> URLRequest {
        guard let url = URL(string: self.url) else { throw Error.invalidURL(self.url) }

        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue

        for (key, value) in self.headers {
            request.addValue(value.description, forHTTPHeaderField: key)
        }

        request.httpBody = self.body?.makeData()

        return request
    }
}
