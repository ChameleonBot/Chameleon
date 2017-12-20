
/// Encapsulates errors received from `SlackBotService`s to provide more detail when they are propagated forward
public enum SlackBotServiceError<T: SlackBotService>: Swift.Error, CustomStringConvertible {
    case error(type: T.Type, error: Swift.Error)

    public var description: String {
        switch self {
        case .error(let type, let error):
            return "\(String(reflecting: type)) > \(String(describing: error))"
        }
    }
}

extension SlackBotService {
    func error(wrapping error: Swift.Error) -> SlackBotServiceError<Self> {
        return .error(type: Self.self, error: error)
    }
}

public extension SlackBot {
    /// Subscribes to an `RTMAPIEvent`
    ///
    /// - note: this provides the same functionality as `slackBot.on(_:handler:)` but any errors
    ///         received are wrapped in a `SlackBotServiceError` to provide more details
    ///
    /// - Parameters:
    ///   - event: The `RTMAPIEvent` to subscribe to
    ///   - service: The `SlackBotService` subscribing to the event
    ///   - handler: The function called when the event occurs. Provides the bot instance and the events data
    func on<T: RTMAPIEvent, U: SlackBotService>(_ event: T.Type, service: U, handler: @escaping (SlackBot, T.EventData) throws -> Void) {
        rtmApi.on(event) { [unowned self] data in
            do {
                try handler(self, data)
            } catch let error {
                throw service.error(wrapping: error)
            }
        }
    }
}
