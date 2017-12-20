import Foundation

public func WebAPIURL(_ pathSegments: String...) -> String {
    return "https://slack.com/api/" + pathSegments.joined(separator: "/")
}

public protocol WebAPIRequest {
    associatedtype Result

    var url: String { get }
    var endpoint: String { get }
    var body: [String: Any?] { get }

    var scopes: [WebAPI.Scope] { get }
    var authenticated: Bool { get }

    func handle(response: NetworkResponse) throws -> Result
}

public extension WebAPIRequest {
    var url: String { return WebAPIURL(endpoint) }
    var body: [String: Any?] { return [:] }
    var scopes: [WebAPI.Scope] { return [] }
    var authenticated: Bool { return true }
}
