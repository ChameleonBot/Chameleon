
var sharedHelpRegister: SlackBotHelpService?

/// Represents a `PatternRepresentable` that can be extended to include help data
public protocol HelpRepresentable: PatternRepresentable {
    /// The topic this pattern relates to, used to group items together.
    ///
    /// This will often be the 'topic' of the `SlackBotService` it comes from, i.e. "Karma"
    var topic: String { get }

    /// A description of the action this pattern performs
    var description: String { get }
}

private extension PatternContext {
    var availability: String {
        switch self {
        case .any: return "channels and IMs"
        case .private: return "IMs"
        case .public: return "channels"
        }
    }
}

/// Service that allows other services to add help and display those items to users
public final class SlackBotHelpService: SlackBotMessageService {
    fileprivate var items: [HelpRepresentable] = []
    private let context: PatternContext

    public init(context: PatternContext = .private) {
        self.context = context
        sharedHelpRegister = self
    }
    public func onMessage(slackBot: SlackBot, message: MessageDecorator, previous: MessageDecorator?) throws {
        guard !items.isEmpty else { return  }

        let isAdmin = try message.sender().value().is_admin
        let phrases = ["help"]

        let pattern: [Matcher]
        switch (context, message.isIM) {
        case (.public, false), (.any, false):
            pattern = [slackBot.me, String.any.orNone, phrases.any]

        case (.private, true), (.any, true):
            pattern = [phrases.any]

        default: return
        }

        guard message.text.patternMatches(against: pattern, strict: false) else { return }

        let data: [String: [HelpRepresentable]] = items
            .filter { !$0.requiresAdmin || isAdmin }
            .filter { !$0.topic.isEmpty }
            .group(by: { $0.topic })
            .filter { !$0.value.isEmpty }

        if data.isEmpty {
            try slackBot.send(
                message.respond().text(["Help me to help you..., ask my owner to add help items"]).makeChatMessage()
            )

        } else {
            for (topic, entries) in data {
                let response = try message
                    .respond()
                    .text([topic.bold])
                    .newLine()

                for entry in entries {
                    response
                        .text([entry.description])
                        .newLine()
                        .text(["Available in", entry.context.availability])
                        .newLine()
                        .text([patternDescription(entry.pattern).pre])
                        .newLine()
                }

                try slackBot.send(response.makeChatMessage())
            }
        }
    }
}

public extension SlackBot {
    /// Register help items
    ///
    /// - Parameter item: The `HelpRepresentable` to register
    @discardableResult
    func registerHelp(item: HelpRepresentable) -> SlackBot {
        sharedHelpRegister?.items.append(item)
        return self
    }
}
