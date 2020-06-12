import Foundation

public class SlashCommandHandler {
    typealias SlashCommandHandler = (SlashCommand) -> Void

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
        handlers[id] = { [weak self] command in
            do { try closure(command) }
            catch let error { self?.onError(error) }
        }
        slashCommandHandlers[slashCommand.normalized] = handlers
        return .init { [weak self] in
            self?.slashCommandHandlers[slashCommand.normalized]?[id] = nil
        }
    }
    public func handle(data: Data) {
        do {
            guard
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let token = json["token"] as? String
                else { throw SlackPacketError.noToken }

            guard token == verificationToken else { throw SlackPacketError.invalidToken }

            let command = try SlashCommand(from: json)

            guard let handlers = slashCommandHandlers[command.command.normalized] else { return }

            handlers.values.forEach { $0(command) }

        } catch let error {
            onError(error)
        }
    }
}
