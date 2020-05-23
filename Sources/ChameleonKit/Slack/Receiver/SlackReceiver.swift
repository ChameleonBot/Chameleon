/// Acts as a single source of incoming data from Slack
public protocol SlackReceiver: AnyObject {
    var onError: (Error) -> Void { get set }

    func listen<T>(for event: SlackEvent<T>, _ closure: @escaping (T) throws -> Void)
    func listen(for slashCommand: SlackSlashCommand, _ closure: @escaping (SlashCommand) throws -> Void)

    func start() throws
}

public enum SlackPacketError: Error, Equatable {
    case noToken
    case invalidToken
    case invalidPacket
}
