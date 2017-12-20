
import Vapor
import HTTP
import Foundation

private extension HTTPMethod {
    var method: HTTP.Method {
        switch self {
        case .GET: return .get
        case .PUT: return .put
        case .POST: return .post
        case .DELETE: return .delete
        }
    }
}

private extension HTTPServerResponse {
    func makeResponse() throws -> Response {
        let headers = self.headers?.map { (HeaderKey($0), $1) } ?? [:]

        let status = Status(statusCode: code)
        let bytes = try (self.body ?? [:]).makeNode(in: nil).bytes

        return Response(
            status: status,
            headers: headers,
            body: .data(bytes ?? [])
        )
    }
}

enum HTTPServerError: Error {
    case failedToStart
}

public final class HTTPServerProvider: HTTPServer {
    // MARK: - Private Properties
    private lazy var server: Droplet? = try? Droplet()

    // MARK: - Lifecycle
    public init() { }

    // MARK: - Public Functions
    public func start() throws {
        guard server != nil else { throw HTTPServerError.failedToStart }

        try server?.run()
    }
    public func register(_ method: HTTPMethod, path: [String], handler: @escaping RequestHandler) {
        server?.register(host: nil, method: method.method, path: path) { request -> ResponseRepresentable in
            let url = try request.uri.makeFoundationURL()
            let headers = request.headers.map { ($0.key, $1) }
            let body = request.responseJson.jsonDictionary ?? [:]

            return try handler(url, headers, body).makeResponse()
        }
    }
}

private extension Request {
    var responseJson: StructuredData {
        if let json = json {
            return json.wrapped

        } else if let data = formURLEncoded {
            return JSON(data).wrapped
        }

        return JSON(.null).wrapped
    }
}

//https://github.com/vapor/json/blob/master/Sources/JSON/JSON%2BParse.swift#L101
private extension StructuredData {
    var foundationJSON: Any {
        switch self {
        case .array(let values):
            return values.map { $0.foundationJSON }
        case .bool(let value):
            return value
        case .bytes(let bytes):
            return bytes.base64Encoded.makeString()
        case .null:
            return NSNull()
        case .number(let number):
            switch number {
            case .double(let value):
                return value
            case .int(let value):
                return value
            case .uint(let value):
                return value
            }
        case .object(let values):
            var dictionary: [String: Any] = [:]
            for (key, value) in values {
                dictionary[key] = value.foundationJSON
            }
            return dictionary
        case .string(let value):
            return value
        case .date(let date):
            let string = Date.outgoingDateFormatter.string(from: date)
            return string
        }
    }
}

private extension StructuredData {
    var jsonDictionary: [String: Any]? {
        return foundationJSON as? [String: Any]
    }
}
