import Foundation

public class SlashCommandHandler {
    typealias SlashCommandHandler = ([String: Any], SlashCommand) -> Void

    // MARK: - Private Properties
    private let verificationToken: String
    private var slashCommandHandlers: [String: [String: SlashCommandHandler]] = [:]

    // MARK: - Public Properties
    public var onError: (Error) -> Void = { _ in fatalError("Error handler not attached") }

    // MARK: - Lifecycle
    public init(verificationToken: String) {
        self.verificationToken = verificationToken
    }

    // MARK: - Public Functions
    public func listen(for slashCommand: SlackSlashCommand, _ closure: @escaping (SlashCommand) throws -> Void) -> Cancellable {
        var handlers = slashCommandHandlers[slashCommand.normalized, default: [:]]
        let id = UUID().uuidString
        handlers[id] = { [unowned self] json, command in
            do {
                try closure(command)

            } catch let error {
                self.onError(SlashCommandError(command: json, error: error))
            }
        }
        slashCommandHandlers[slashCommand.normalized] = handlers
        return .init { [weak self] in
            self?.slashCommandHandlers[slashCommand.normalized]?[id] = nil
        }
    }
    public func handle(data: Data) {
        do {
            let jsonPacket = try JSONSerialization.jsonObject(with: data, options: [])

            guard let json = jsonPacket as? [String: Any] else { throw SlackPacketError.invalidPacket(jsonPacket) }
            guard let token = json["token"] as? String else { throw SlackPacketError.noToken(json) }
            guard token == verificationToken else { throw SlackPacketError.invalidToken(json) }

            do {
                let command = try SlashCommand(from: json)
                guard let handlers = slashCommandHandlers[command.command.normalized] else { return }
                handlers.values.forEach { $0(json, command) }

            } catch let error {
                throw SlashCommandError(command: json, error: error)
            }

        } catch let error {
            onError(error)
        }
    }
}
