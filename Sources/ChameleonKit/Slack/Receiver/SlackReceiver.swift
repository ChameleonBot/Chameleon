/// Acts as a single source of incoming data from Slack
public protocol SlackReceiver: AnyObject {
    var onError: (Error) -> Void { get set }

    @discardableResult
    func listen<T>(for event: SlackEvent<T>, _ closure: @escaping (T) throws -> Void) -> Cancellable

    @discardableResult
    func listen(for slashCommand: SlackSlashCommand, _ closure: @escaping (SlashCommand) throws -> Void) -> Cancellable

    func registerAction(id: String, closure: @escaping () throws -> Void)

    func start() throws
}

public enum SlackPacketError: Error {
    case noToken([String: Any])
    case invalidToken([String: Any])
    case invalidPacket(Any)
}
