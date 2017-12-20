
public enum WebSocketError: Error {
    case invalidPacket
}

public protocol WebSocket {
    typealias ConnectHandler = () -> Void
    typealias DisconnectHandler = () -> Void
    typealias TextHandler = (String) -> Void

    func connect(
        to url: String,
        onConnect: @escaping ConnectHandler,
        onDisconnect: @escaping DisconnectHandler,
        onText: @escaping TextHandler,
        onError: @escaping ErrorHandler
    ) throws

    func send(packet: [String: Any]) throws

    func disconnect()
}
