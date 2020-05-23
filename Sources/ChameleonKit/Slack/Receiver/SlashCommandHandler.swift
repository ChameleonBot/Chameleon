import Foundation

public class SlashCommandHandler {
    typealias SlashCommandHandler = (SlashCommand) throws -> Void

    // MARK: - Private Properties
    private let verificationToken: String
    private var slashCommandHandlers: [String: [SlashCommandHandler]] = [:]

    // MARK: - Lifecycle
    public init(verificationToken: String) {
        self.verificationToken = verificationToken
    }

    // MARK: - Public Functions
    public func listen(for slashCommand: SlackSlashCommand, _ closure: @escaping (SlashCommand) throws -> Void) {
        var handlers = slashCommandHandlers[slashCommand.normalized, default: []]
        handlers.append(closure)
        slashCommandHandlers[slashCommand.normalized] = handlers
    }
    public func handle(data: Data) throws {
        guard
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let token = json["token"] as? String
            else { throw SlackPacketError.noToken }

        guard token == verificationToken else { throw SlackPacketError.invalidToken }

        let command = try SlashCommand(from: json)
        guard let handlers = slashCommandHandlers[command.command.normalized] else { return }
        try handlers.forEach { try $0(command) }
    }
}
