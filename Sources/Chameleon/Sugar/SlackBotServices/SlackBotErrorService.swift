
private let TargetKey = "SlackBotErrorServiceTarget"

/// Service that allows the bot to notify a given `Channel` when errors occur
public final class SlackBotErrorService: SlackBotMessageService {
    // MARK: - Private Properties
    private let store: KeyValueStore
    private var target: ModelPointer<Channel>? {
        get {
            return try? store.get(forKey: TargetKey)
        }
        set {
            if let value = newValue {
                store.set(value: value, forKey: TargetKey)
            } else {
                store.remove(key: TargetKey)
            }
        }
    }

    // MARK: - Lifecycle
    public init(store: KeyValueStore, target: ModelPointer<Channel>? = nil) {
        self.store = store

        if let target = target {
            store.set(value: target, forKey: TargetKey)
        }
    }

    // MARK: - Public
    public func configure(slackBot: SlackBot) {
        configureMessageService(slackBot: slackBot)

        slackBot.registerHelp(item: Patterns.target)
    }
    public func error(slackBot: SlackBot, error: Error) {
        do {
            guard let target = try target?.value() else { return }

            let message = try ChatMessageDecorator(target: target)
                .text(["Error occurred".bold])
                .newLine()
                .text([String(describing: error)])
                .makeChatMessage()

            try slackBot.send(message)

        } catch let error {
            defaultErrorHandler(error)
        }
    }
    public func onMessage(slackBot: SlackBot, message: MessageDecorator, previous: MessageDecorator?) throws {
        _ = try? slackBot.route(message, matching: Patterns.target) { bot, msg, match in
            do {
                let target: ModelPointer<Channel> = try match.value(key: "channel")

                self.target = target

                try bot
                    .send(try msg
                        .respond()
                        .text(["Sending errors to", try target.value(), "(\(target.id))"])
                        .makeChatMessage()
                )

            } catch let error {
                defaultErrorHandler(error)
            }
        }
    }
}

private extension SlackBotErrorService {
    enum Patterns: HelpRepresentable {
        case target

        var topic: String { return "Error Reporting" }
        var description: String {
            switch self {
            case .target: return "Tell the bot where to send error reports"
            }
        }
        var pattern: [Matcher] {
            switch self {
            case .target:
                return [
                    ["report", "send", "deliver"].any,
                    ["errors", "problems", "issues", "trouble"].any,
                    "to",
                    Channel.any.using(key: "channel")
                ]
            }
        }
        var requiresAdmin: Bool {
            return true
        }
    }
}
