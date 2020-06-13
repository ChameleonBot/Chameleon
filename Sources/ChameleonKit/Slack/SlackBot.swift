public class SlackBot {
    // MARK: - Private Properties
    private let dispatcher: SlackDispatcher
    private let receiver: SlackReceiver
    private var errorHandlers: [(Error) -> Void] = []
    private var hydrationCache: [String: Any] = [:]

    // MARK: - Public Properties
    public private(set) var me: User!

    // MARK: - Lifecycle
    public init(dispatcher: SlackDispatcher, receiver: SlackReceiver) {
        self.dispatcher = dispatcher
        self.receiver = receiver

        receiver.onError = { [unowned self] in self.receivedError($0) }
    }

    // MARK: - Public Functions
    public func start() throws {
        let authentication = try perform(.authDetails)
        me = try perform(.user(authentication.user_id))
        try receiver.start()
    }

    // MARK: - Public Functions - Receiving
    @discardableResult
    public func listen<T>(for event: SlackEvent<T>, closure: @escaping (SlackBot, T) throws -> Void) -> Cancellable {
        return receiver.listen(for: event) { [unowned self] in try closure(self, $0) }
    }
    public func listen(for slashCommand: SlackSlashCommand, _ closure: @escaping (SlackBot, SlashCommand) throws -> Void) -> Cancellable {
        return receiver.listen(for: slashCommand) { [unowned self] in try closure(self, $0) }
    }

    // MARK: - Public Functions - Dispatching
    @discardableResult
    public func perform<T>(_ action: SlackAction<T>) throws -> T {
        do {
            action.setup(receiver)
            return try dispatcher.perform(action)
            
        } catch let error {
            throw SlackActionError(action: action, error: error)
        }
    }
    public func lookup<T: Hydratable>(_ identifier: Identifier<T>) throws -> T {
        if let existing = hydrationCache[identifier.cacheKey] as? T {
            return existing

        } else {
            let value = try perform(T.hydrate(with: identifier))
            hydrationCache[identifier.cacheKey] = value
            return value
        }
    }
    public func registerAction(id: String, closure: @escaping () throws -> Void) {
        receiver.registerAction(id: id, closure: closure)
    }

    // MARK: - Public Functions - Errors
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

private extension Identifier {
    var cacheKey: String { return "\(T.self):\(rawValue)" }
}
