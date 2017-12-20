import Foundation
import Dispatch

private enum Endpoint: String {
    case login
    case oauth
}

private extension OAuthAuthenticator {
    enum Error: Swift.Error {
        case invalidState
        case invalidURL
        case oAuthError(String)
    }
    struct Authentication {
        let bot_access_token: String
        let access_token: String
    }
}

extension OAuthAuthenticator.Authentication: WebAPIAuthenticator {
    func token<T: WebAPIRequest>(for method: T) throws -> String {
        if (method.scopes.isEmpty) {
            return self.bot_access_token
        }
        return self.access_token
    }
}

private extension WebAPIAuthenticator {
    var oAuthAuthentication: OAuthAuthenticator.Authentication? {
        return self as? OAuthAuthenticator.Authentication
    }
}


/// Provides OAuth based authentication
public final class OAuthAuthenticator: SlackAuthenticator {
    typealias ResultClosure = (Result<SlackAuthentication>) -> Void

    // MARK: - Constants
    fileprivate enum Keys {
        static let namespace = "OAuthAuthenticator"
        static let authentication = "Authentication"
    }

    // MARK: - Public Properties
    public let clientId: String
    public let clientSecret: String
    public let scopes: Set<WebAPI.Scope>

    // MARK: - Private Properties
    fileprivate let network: Network
    fileprivate let storage: Storage
    fileprivate var state = ""
    fileprivate var authentication: SlackAuthentication? {
        didSet {
            if let authentication = authentication?.webApiAuthenticator.oAuthAuthentication {
                let value = [authentication.bot_access_token, authentication.access_token].joined(separator: ",")
                storage.set(value: value, forKey: Keys.authentication, in: Keys.namespace)

            } else {
                storage.remove(key: Keys.authentication, from: Keys.namespace)
            }
        }
    }
    fileprivate var result: ResultClosure?
    fileprivate let redirectUri: String?
    fileprivate var authWorkItem: DispatchWorkItem?

    // MARK: - Lifecycle
    /// Create a new instance
    ///
    /// - Parameters:
    ///   - network: The `Network` used to do the oauth exchange
    ///   - storage: The `Storage` used to persist the authentication data
    ///   - clientId: The client id provided by Slack
    ///   - clientSecret: The client secret provided by Slack
    ///   - scopes: The `WebAPI.Scope`s this bot requires
    ///   - redirectUri: Optional redirect url to be included in the oauth exchange
    public init(network: Network, storage: Storage, clientId: String, clientSecret: String, scopes: Set<WebAPI.Scope>, redirectUri: String? = nil) {
        self.network = network
        self.storage = storage
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.scopes = Set([.bot] + scopes)
        self.redirectUri = redirectUri

        restoreAuthentication()
    }

    // MARK: - Public Functions
    public func configure(slackBot: SlackBot) {
        slackBot.httpServer.register(
            .GET,
            path: [Endpoint.login.rawValue],
            target: self, OAuthAuthenticator.handleLogin
        )
        slackBot.httpServer.register(
            .GET,
            path: [Endpoint.oauth.rawValue],
            target: self, OAuthAuthenticator.handleOauth
        )
    }
    public func authenticate() throws -> SlackAuthentication {
        let group = DispatchGroup()
        group.enter()

        var authenticationResult: Result<SlackAuthentication>?
        authenticate { result in
            authenticationResult = result
            group.leave()
        }
        group.wait()

        switch authenticationResult {
        case .success(let authentication)?:
            return authentication
        case .failure(let error)?:
            throw error
        case .none:
            fatalError("This should never happen")
        }
    }
    public func reset() {
        self.authentication = nil
    }

    // MARK: - Private Functions
    private func authenticate(result: @escaping (Result<SlackAuthentication>) -> Void) {
        authWorkItem?.cancel()

        if let authentication = authentication {
            return result(.success(authentication))
        }

        self.state = "\(Int.random(min: 1, max: 999999))"

        self.result = { [weak self] in
            self?.state = ""
            result($0)
        }
        print("Ready to authenticate: Please visit /login")
    }
}

// MARK: - State Management
private extension OAuthAuthenticator {
    func createAuthentication(response: NetworkResponse) throws -> SlackAuthentication  {
        guard let json = response.jsonDictionary else { throw Error.oAuthError("Invalid Response") }

        let decoder = Decoder(data: json)

        let authentication = Authentication(
            bot_access_token: try decoder.value(at: ["bot", "bot_access_token"]),
            access_token: try decoder.value(at: ["access_token"])
        )

        return SlackAuthentication(
            token: authentication.bot_access_token,
            webApiAuthenticator: authentication
        )
    }
    func restoreAuthentication() {
        guard let string: String = try? storage.get(key: Keys.authentication, from: Keys.namespace)
            else { return }

        let components = string.components(separatedBy: ",")

        guard components.count == 2 else { return }

        let authentication = Authentication(
            bot_access_token: components[0],
            access_token: components[1]
        )

        self.authentication = SlackAuthentication(
            token: components[0],
            webApiAuthenticator: authentication
        )
    }
}

// MARK: - HTTPServer
private extension OAuthAuthenticator {
    func handleLogin(url: URL, headers: [String: String], body: [String: Any]) throws -> HTTPServerResponse {
        guard !state.isEmpty else { return HTTPResponse.ok }
        return try oAuthAuthorizeURL()
    }
    func handleOauth(url: URL, headers: [String: String], body: [String: Any]) throws -> HTTPServerResponse {
        guard
            let components = URLComponents(string: url.absoluteString),
            let state = components.queryItems?.first(where: { $0.name == "state" })?.value,
            let code = components.queryItems?.first(where: { $0.name == "code" })?.value,
            !state.isEmpty, state == self.state
            else { return HTTPResponse.fail(Error.invalidState) }

        if let error = components.queryItems?.first(where: { $0.name == "error" })?.name {
            return HTTPResponse.fail(Error.oAuthError(error))
        }

        let item = DispatchWorkItem {
            let url = Result<URL> { try self.oAuthAccessURL(code: code) }

            let result = url
                .map { NetworkRequest(method: .GET, url: $0.absoluteString) }
                .map { try self.network.perform(request: $0) }
                .map(self.createAuthentication)
                .then { self.authentication = $0 }

            self.result?(result)
        }
        authWorkItem = item
        DispatchQueue.global().async(execute: item)

        return HTTPResponse.ok
    }
}

//MARK: - URL Builders
private extension OAuthAuthenticator {
    func oAuthAuthorizeURL() throws -> URL {
        var components = URLComponents(string: "https://slack.com/oauth/authorize")

        components?.queryItems = [
            URLQueryItem(name: "client_id", value: self.clientId),
            URLQueryItem(name: "scope", value: self.scopes.map({ $0.rawValue }).joined(separator: ",")),
            URLQueryItem(name: "state", value: self.state),
            URLQueryItem(name: "redirect_uri", value: redirectUri),
        ]

        guard let url = components?.url else { throw Error.invalidURL }
        return url
    }
    func oAuthAccessURL(code: String) throws -> URL {
        var components = URLComponents(string: "https://slack.com/api/oauth.access")
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: self.clientId),
            URLQueryItem(name: "client_secret", value: self.clientSecret),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: redirectUri),
        ]
        
        guard let url = components?.url else { throw Error.invalidURL }
        return url
    }
}
