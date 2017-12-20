
extension SlackBot {
    /// Defines the configuration used by this bot instance
    public struct Configuration {        
        public let authenticator: SlackAuthenticator
        public let reconnectionStrategy: ReconnectionStrategy
        public let modelVendor: SlackModelTypeVendor
        public let verificationToken: String?

        /// Create a new instance
        ///
        /// - Parameters:
        ///   - authenticator: The `SlackAuthenticator` that will be used to authenticate the bot
        ///   - reconnectionStrategy: The `ReconnectionStrategy` that will be used when the bot is disconnected
        ///   - modelVendor: The `SlackModelTypeVendor` that will be used to convert object ids into complete object models
        ///   - verificationToken: The verification token used for _slack application_ level slash commands
        public init(
            authenticator: SlackAuthenticator,
            reconnectionStrategy: ReconnectionStrategy,
            modelVendor: SlackModelTypeVendor,
            verificationToken: String? = nil
            )
        {
            self.authenticator = authenticator
            self.reconnectionStrategy = reconnectionStrategy
            self.modelVendor = modelVendor
            self.verificationToken = verificationToken
        }
    }
}
