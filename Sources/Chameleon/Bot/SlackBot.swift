
import Foundation
import Dispatch

/// Represents the core bot used for connecting to a Slack team
public class SlackBot {
    // MARK: - Private Properties
    private var exit = false

    // MARK: - Internal Properties
    private(set) var services: [SlackBotService]
    let config: Configuration
    let webApi: WebAPI
    let rtmApi: RTMAPI
    let httpServer: HTTPServer

    // MARK: - Public Properties
    private(set) public var me: BotUser!

    // MARK: - Lifecycle
    /// Create a `SlackBot` instance
    ///
    /// - Parameters:
    ///   - config: The `Configuration` to use for this instance
    ///   - webApi: The `WebAPI` used for sending web api requests
    ///   - rtmApi: The `RTMAPI` used for receiving rtm api events
    ///   - httpServer: The `HTTPServer` used for features such as slash command and interactive buttons
    ///   - services: The `SlackBotService` that provide the functionality for this instance
    public init(config: Configuration, webApi: WebAPI, rtmApi: RTMAPI, httpServer: HTTPServer, services: [SlackBotService]) {
        self.config = config
        self.webApi = webApi
        self.rtmApi = rtmApi
        self.httpServer = httpServer
        self.services = services

        sharedModelVendor = config.modelVendor
        rtmApi.onError = { self.error($0) }

        config.authenticator.configure(slackBot: self)

        configureHTTPServer()
        configureSlashCommands()
        startHTTPServer()

        configureServices()
    }

    // MARK: - Public Functions
    /// Start the bot
    public func start() {
        exit = false

        let group = DispatchGroup()
        group.enter()

        do {
            let authentication = try config.authenticator.authenticate()

            webApi.use(authenticator: authentication.webApiAuthenticator)

            let request = RTMConnect(token: authentication.token)
            let connection = try webApi.perform(request: request)

            me = connection.bot

            rtmApi.onConnected = { [unowned self] in
                self.connected()
            }
            rtmApi.onDisconnected = { group.leave() }

            // this call is blocking when successful
            try rtmApi.connect(to: connection.url)

        } catch let error {
            self.error(error)
            group.leave()
        }

        group.wait()

        let reconnect = config.reconnectionStrategy.reconnect() && !exit
        disconnected(reconnect: reconnect)

        if reconnect {
            start()
        } else {
            config.authenticator.reset()
        }
    }

    /// Restart the bot
    public func restart() {
        config.reconnectionStrategy.reset()
        rtmApi.disconnect()
    }

    /// Stop the bot
    public func stop() {
        exit = true
        rtmApi.disconnect()
    }

    // MARK: - Internal Functions
    func error(_ error: Swift.Error) {
        defaultErrorHandler(error)
        services.forEach { $0.error(slackBot: self, error: error) }
    }
    func add(service: SlackBotService) {
        services.append(service)
    }

    // MARK: - Private Functions
    private func configureServices() {
        services.forEach { $0.configure(slackBot: self) }
    }
    private func connected() {
        config.reconnectionStrategy.reset()
        services.forEach { $0.connected(slackBot: self) }
    }
    private func disconnected(reconnect: Bool) {
        services.forEach { $0.disconnected(slackBot: self, reconnecting: reconnect) }
    }
}
