
import Foundation
import Dispatch

public final class RTMAPI {
    typealias EventHandler = ([String: Any]) throws -> Void
    public typealias ConnectHandler = () -> Void
    public typealias DisconnectHandler = () -> Void

    // MARK: - Public Properties
    public private(set) var connected: Bool = false
    public var onError: ErrorHandler?
    public var onConnected: ConnectHandler?
    public var onDisconnected: DisconnectHandler?

    // MARK: - Internal Properties
    let socket: WebSocket
    var pingPong: DispatchWorkItem?

    // MARK: - Private Properties
    private var registeredEvents: [EventHandler] = []

    // MARK: - Lifecycle
    public init(socket: WebSocket) {
        self.socket = socket
    }

    // MARK: - Public
    public func connect(to url: String) throws {
        try socket.connect(
            to: url,
            onConnect: { [weak self] in
                print("Connected")
                self?.connected = true
                self?.startPingPong()
                self?.onConnected?()
            },
            onDisconnect: { [weak self] in
                print("Disconnected")
                self?.stopPingPong()
                self?.onDisconnected?()
            },
            onText: { [weak self] text in
                self?.received(string: text)
            },
            onError: { [weak self] error in
                self?.onError?(error)
            }
        )
    }
    public func disconnect() {
        socket.disconnect()
        connected = false
    }
    public func on<T: RTMAPIEvent>(_: T.Type, handler: @escaping (T.EventData) throws -> Void) {
        let eventHandler: EventHandler = { packet in
            guard T.canMake(from: packet) else { return }

            do {
                let eventData = try T.handle(
                    packet: packet
                )

                try handler(eventData)

            } catch let error {
                throw EventError.error(type: T.self, error: error)
            }
        }

        registeredEvents.append(eventHandler)
    }

    // MARK: - Private
    private func received(string: String) {
        guard
            !registeredEvents.isEmpty,
            let packet = string.makeDictionary()
            else { return }

        for handler in registeredEvents {
            do {
                try handler(packet)
            } catch let error {
                onError?(error)
            }
        }
    }
}
