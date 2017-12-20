
/// Defines the different types of slash commands
public enum SlashCommandSource {
    /// Represents an _application_ level slash command
    /// This uses the `verificationToken` provided in the `SlackBot.Configuration`
    /// to ensure the command comes from a trusted source
    case app(command: String)

    /// Represents a _team_ level slash command
    /// This uses the provided `token` to ensure the command comes
    /// from a trusted source
    case team(command: String, token: String)
}

/// Allows _application_ level slash commands to be represented by string literals
extension SlashCommandSource: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .app(command: value)
    }
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

public protocol SlackBotSlashCommandService: SlackBotService {
    /// The commands supported by this `SlackBotSlashCommandService` instance
    var slashCommands: [SlashCommandSource] { get }

    /// Called when one of the registered slash commands is triggered
    ///
    /// - Parameters:
    ///   - slackBot: The `SlackBot` instance
    ///   - command: The `SlashCommand` with the command details
    func onSlashCommand(slackBot: SlackBot, command: SlashCommand) throws
}
