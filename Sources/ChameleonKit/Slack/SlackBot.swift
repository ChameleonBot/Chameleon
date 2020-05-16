public class SlackBot {
    // MARK: - Private Properties
    private let dispatcher: SlackDispatcher
    private let receiver: SlackReceiver
    private var errorHandlers: [(Error) -> Void] = []

    // MARK: - Lifecycle
    public init(dispatcher: SlackDispatcher, receiver: SlackReceiver) {
        self.dispatcher = dispatcher
        self.receiver = receiver

        receiver.onError = { [unowned self] in self.receivedError($0) }
    }

    // MARK: - Public Functions
    public func start() throws {
        try receiver.start()
    }
    public func listen<T>(for event: SlackEvent<T>, closure: @escaping (SlackBot, T) throws -> Void) {
        receiver.listen(for: event) { [unowned self] in try closure(self, $0) }
    }
    public func listen(for slashCommand: SlackSlashCommand, _ closure: @escaping (SlackBot, SlashCommand) throws -> Void) {
        receiver.listen(for: slashCommand) { [unowned self] in try closure(self, $0) }
    }
    public func perform<T>(_ action: SlackAction<T>) throws -> T {
        do {
            return try dispatcher.perform(action)

        } catch let error {
            receivedError(error)
            throw error
        }
    }

    public enum ErrorEvent { case error }
    public func listen(for error: ErrorEvent, closure: @escaping (SlackBot, Error) throws -> Void) {
        errorHandlers.append({ [unowned self] error in
            do {
                try closure(self, error)
            } catch let error {
                fatalError("UNRECOVERABLE ERROR: \(error)")
            }
        })
    }

    // MARK: - Private Properties
    private func receivedError(_ error: Error) {
        errorHandlers.forEach { $0(error) }
    }
}
