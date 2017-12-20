
/// Provides the authentication data for a Slack session
public struct SlackAuthentication {
    /// The token used to connect to Slack
    public let token: String

    /// The `WebAPIAuthenticator` that the `WebAPI` instance will use to authentication web api requests
    public let webApiAuthenticator: WebAPIAuthenticator
}

/// Represents an object that handles authenticating with Slack
public protocol SlackAuthenticator {
    /// Configure the `SlackAuthenticator`
    ///
    /// Called once when the bot is created
    func configure(slackBot: SlackBot)

    /// Obtain a `SlackAuthentication` that can be used to connect
    func authenticate() throws -> SlackAuthentication

    /// Resets any internal state related to this `SlackAuthenticator`
    func reset()
}
