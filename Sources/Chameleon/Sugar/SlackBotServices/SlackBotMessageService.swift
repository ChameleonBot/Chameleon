
/// Service provides an easier way of working with messages
public protocol SlackBotMessageService: SlackBotService {
    /// Allows restricting of non-standard messages to only those matching these provided `Message.Subtype`s
    ///
    /// - Default: `.me_message` and `.message_changed`
    var allowedSubTypes: [Message.Subtype] { get }

    /// Called when a message is received
    ///
    /// - Parameters:
    ///   - message: A `MessageDecorator` wrapping the received `Message`
    ///   - previous: If `message` is an edited message this will be the previous/original message, otherwise `nil`
    func onMessage(slackBot: SlackBot, message: MessageDecorator, previous: MessageDecorator?) throws
}

extension SlackBotMessageService {
    public var allowedSubTypes: [Message.Subtype] { return [.me_message, .message_changed] }

    public func configure(slackBot: SlackBot) {
        configureMessageService(slackBot: slackBot)
    }

    public func configureMessageService(slackBot: SlackBot) {
        slackBot.on(message.self, service: self) { [unowned self] bot, data in
            if let subtype = data.message.subtype, !self.allowedSubTypes.contains(subtype) {
                return
            }

            let message = MessageDecorator(message: data.message)

            guard (try? message.sender().id) != bot.me.id else { return }

            try self.onMessage(
                slackBot: bot,
                message: message,
                previous: data.previous.map(MessageDecorator.init)
            )
        }
    }
}
