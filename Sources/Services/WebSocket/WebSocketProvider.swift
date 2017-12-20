
import Vapor

public final class WebSocketProvider: WebSocket {
    // MARK: - Private
    private let factory = WebSocketFactory()
    private var socket: Vapor.WebSocket?
    private var onError: ErrorHandler?

    // MARK: - Lifecycle
    public init() { }

    // MARK: - Public Functions
    public func connect(
        to url: String,
        onConnect: @escaping ConnectHandler,
        onDisconnect: @escaping DisconnectHandler,
        onText: @escaping TextHandler,
        onError: @escaping ErrorHandler
        ) throws
    {
        self.onError = onError

        try factory.connect(to: url) { [weak self] socket in

            self?.socket = socket

            onConnect()
            socket.onClose = { _, _, _, _ in onDisconnect() }
            socket.onText = { _, string in onText(string) }

        }
    }
    public func send(packet: [String: Any]) throws {
        guard
            let string = packet.makeString()
            else { onError?(WebSocketError.invalidPacket); return }

        try socket?.send(string)
    }
    public func disconnect() {
        try? socket?.close()
    }
}
