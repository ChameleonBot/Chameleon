
/// Represents an object that provides functionality for a bot instance
public protocol SlackBotService: class {
    /// Provides a chance to configure this `SlackBotService`.
    ///
    /// This is where you would do things like event subscription
    ///
    /// Called once when the bot is created.
    func configure(slackBot: SlackBot)

    /// Called each time the bot connects
    func connected(slackBot: SlackBot)

    /// Called each time the bot disconnects
    ///   - reconnecting: `true` if the bot will attempt to reconnect, otherwise `false`
    func disconnected(slackBot: SlackBot, reconnecting: Bool)

    /// Called each time an error occurs
    func error(slackBot: SlackBot, error: Error)
}

extension SlackBotService {
    public func connected(slackBot: SlackBot) { }
    public func disconnected(slackBot: SlackBot, reconnecting: Bool) { }
    public func error(slackBot: SlackBot, error: Error) { }
}
