import ChameleonKit
import Foundation

extension SlackBot {
    public static let validTestToken = "valid_token"
}

class MockSlackReceiver: SlackReceiver {
    private let handler: SlackEventHandler

    public var onError: (Error) -> Void = { _ in }

    init(verificationToken: String = SlackBot.validTestToken) {
        self.handler = SlackEventHandler(verificationToken: verificationToken)
    }

    @discardableResult
    func listen<T>(for event: SlackEvent<T>, _ closure: @escaping (T) throws -> Void) -> Cancellable {
        return handler.listen(for: event, closure)
    }
    func listen(for slashCommand: SlackSlashCommand, _ closure: @escaping (SlashCommand) throws -> Void) {
        fatalError("Not implemented yet")
    }
    func start() throws { }

    // MARK: - Mocking
    func receive(_ fixture: FixtureSource<SlackReceiver>) throws {
        try handler.handle(data: fixture.data())
    }
}
