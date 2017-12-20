
public extension SlackBot {
    /// Create a new instance
    ///
    /// - Parameters:
    ///   - authenticator: The `SlackAuthenticator` that will be used to authenticate the bot
    ///   - verificationToken: The verification token used for _slack application_ level slash commands
    ///   - services: The `SlackBotService`s that provide the functionality for this instance
    public convenience init(
        authenticator: SlackAuthenticator,
        verificationToken: String? = nil,
        services: [SlackBotService]
        )
    {
        let socket = WebSocketProvider()
        let network = NetworkProvider()
        let httpServer = HTTPServerProvider()

        let webApi = WebAPI(network: network)
        let rtmApi = RTMAPI(socket: socket)

        let config = SlackBot.Configuration(
            authenticator: authenticator,
            reconnectionStrategy: DefaultReconnectionStrategy(
                maxRetries: 5,
                delay: { $0 * 2 }
            ),
            modelVendor: DefaultSlackModelTypeVendor(webApi: webApi),
            verificationToken: verificationToken
        )

        self.init(
            config: config,
            webApi: webApi,
            rtmApi: rtmApi,
            httpServer: httpServer,
            services: services
        )
    }
}
