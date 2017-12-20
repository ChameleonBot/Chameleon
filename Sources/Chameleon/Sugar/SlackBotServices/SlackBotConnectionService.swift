
private let TargetKey = "SlackBotConnectionServiceTarget"

/// Service that allows the bot to notify a given `Channel` when it comes online
public final class SlackBotConnectionService: SlackBotMessageService {
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
    public func connected(slackBot: SlackBot) {
        guard let me = slackBot.me else { return }

        send(message: [me, "reporting for duty!"], using: slackBot)
    }
    public func disconnected(slackBot: SlackBot, reconnecting: Bool) {
        guard !reconnecting, let me = slackBot.me else { return }

        send(message: [me, "signing off."], using: slackBot)
    }
    public func onMessage(slackBot: SlackBot, message: MessageDecorator, previous: MessageDecorator?) throws {
        try slackBot.route(message, matching: Patterns.target) { bot, msg, match in
            let target: ModelPointer<Channel> = try match.value(key: "channel")

            self.target = target

            try bot
                .send(try msg
                    .respond()
                    .text(["Sending connection status to", try target.value(), "(\(target.id))"])
                    .makeChatMessage()
            )
        }
    }

    // MARK: - Private
    private func send(message: [ChatMessageSegmentRepresentable], using slackBot: SlackBot) {
        guard let target = target.flatMap({ try? $0.value() }) else { return }

        do {
            let message = try ChatMessageDecorator(target: target)
                .text(message)
                .makeChatMessage()

            try slackBot.send(message)

        } catch { }
    }
}

private extension SlackBotConnectionService {
    enum Patterns: HelpRepresentable {
        case target

        var topic: String { return "Connection Status Reporting" }
        var description: String {
            switch self {
            case .target: return "Tell the bot where to send its connection status"
            }
        }
        var pattern: [Matcher] {
            switch self {
            case .target:
                return [
                    ["report", "send", "deliver"].any,
                    "connection status to",
                    Channel.any.using(key: "channel")
                ]
            }
        }
        var requiresAdmin: Bool {
            return true
        }
    }
}

