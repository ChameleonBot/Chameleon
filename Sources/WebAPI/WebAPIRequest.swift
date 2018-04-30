import Foundation

public let DefaultBaseURL = "https://slack.com/api/"

public func WebAPIURL(base: String, _ pathSegments: String...) -> String {
    return base + pathSegments.joined(separator: "/")
}

public enum Encoding {
    case form, json
}

public protocol WebAPIRequest {
    associatedtype Result

    var url: String { get }
    var encoding: Encoding { get }
    var endpoint: String { get }
    var body: [String: Any?] { get }

    var scopes: [WebAPI.Scope] { get }
    var authenticated: Bool { get }

    func handle(response: NetworkResponse) throws -> Result
}

public extension WebAPIRequest {
    var url: String { return WebAPIURL(base: DefaultBaseURL, endpoint) }
    var encoding: Encoding { return .form }
    var body: [String: Any?] { return [:] }
    var scopes: [WebAPI.Scope] { return [] }
    var authenticated: Bool { return true }
}
