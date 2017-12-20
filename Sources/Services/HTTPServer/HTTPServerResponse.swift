
import Foundation

public protocol HTTPServerResponse {
    var code: Int { get }
    var headers: [String: String]? { get }
    var body: [String: Any]? { get }
}

extension HTTPServerResponse {
    public var headers: [String : String]? { return nil }
    public var body: [String : Any]? { return nil }
}

extension URL: HTTPServerResponse {
    public var code: Int { return 307 }
    public var headers: [String : String]? {
        let url: String? = self.absoluteString
        guard let urlString = url else { fatalError("Invalid URL: \(self)") }

        return ["Location": urlString]
    }
}

public enum HTTPResponse: HTTPServerResponse {
    case ok, fail(Error)

    public var code: Int {
        switch self {
        case .ok: return 200
        case .fail: return 500
        }
    }
    public var body: [String : Any]? {
        switch self {
        case .ok:
            return [:]
        case .fail(let error):
            return ["error": "\(error)"]
        }
    }
}
