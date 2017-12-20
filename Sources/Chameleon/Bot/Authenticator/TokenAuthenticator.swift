
/// Provides simple token based authentication
public struct TokenAuthenticator: SlackAuthenticator {
    // MARK: - Public Properties
    public let token: String

    // MARK: - Lifecycle
    /// Create a new ininstance
    ///
    /// - Parameter token: The `token` to use for authentication and web api requests
    public init(token: String) {
        self.token = token
    }

    // MARK: - Public Functions
    public func configure(slackBot: SlackBot) {
        //
    }
    public func authenticate() throws -> SlackAuthentication {
        return SlackAuthentication(
            token: token,
            webApiAuthenticator: self
        )
    }
    public func reset() {
        //
    }
}

extension TokenAuthenticator: WebAPIAuthenticator {
    public func token<T: WebAPIRequest>(for method: T) throws -> String {
        //token based authentication automatically unlocks all WebAPI methods
        return token
    }
}
