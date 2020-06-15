import ChameleonKit
import Foundation

extension SlackBot {
    public static let validTestToken = "valid_token"
}

class MockSlackReceiver: SlackReceiver {
    private let eventHandler: SlackEventHandler
    private let slashCommandHandler: SlashCommandHandler
    private let interactionHandler: InteractionHandler

    public var onError: (Error) -> Void = { _ in }

    init(verificationToken: String = SlackBot.validTestToken) {
        self.eventHandler = SlackEventHandler(verificationToken: verificationToken)
        self.slashCommandHandler = SlashCommandHandler(verificationToken: verificationToken)
        self.interactionHandler = InteractionHandler(verificationToken: verificationToken)

        self.eventHandler.onError = { [weak self] in self?.onError($0) }
        self.slashCommandHandler.onError = { [weak self] in self?.onError($0) }
    }

    @discardableResult
    func listen<T>(for event: SlackEvent<T>, _ closure: @escaping (T) throws -> Void) -> Cancellable {
        return eventHandler.listen(for: event, closure)
    }
    @discardableResult
    func listen(for slashCommand: SlackSlashCommand, _ closure: @escaping (SlashCommand) throws -> Void) -> Cancellable {
        return slashCommandHandler.listen(for: slashCommand, closure)
    }
    func registerAction(id: String, closure: @escaping (Interaction) throws -> Void) {
        interactionHandler.registerAction(id: id, closure: closure)
    }
    func start() throws { }

    // MARK: - Mocking
    func receive(_ fixture: FixtureSource<SlackReceiver>) throws {
        try eventHandler.handle(data: fixture.data())
    }
}
