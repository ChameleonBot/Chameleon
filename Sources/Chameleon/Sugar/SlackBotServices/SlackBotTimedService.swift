
import Foundation

/// Service that allows actions to be performed at a given interval
///
/// - note: This relies on Slacks ping/pong to provide a _low resolution_ timer implementation
public class SlackBotTimedService: SlackBotService {
    public typealias TimerAction = (SlackBot, Pong) throws -> Void

    private let id: String
    private let storage: KeyValueStore
    private let interval: TimeInterval
    private let action: TimerAction

    private func key(_ string: String = #function) -> String {
        return "\(SlackBotTimedService.self)\(id):\(string)"
    }
    private var lastExecuted: Int {
        get { return (try? storage.get(forKey: key())) ?? 0 }
        set { storage.set(value: newValue, forKey: key()) }
    }

    /// Create a new instance
    ///
    /// - Parameters:
    ///   - id: A unique identifier to represent this instance
    ///   - storage: The `KeyValueStore` used to persist the state for this instance
    ///   - interval: The interval in seconds at which this instances action should be performed
    ///   - action: The action to perform at each `interval`
    public init(id: String, storage: KeyValueStore, interval: TimeInterval, action: @escaping TimerAction) {
        self.id = id
        self.storage = storage
        self.interval = interval
        self.action = action
    }

    public func configure(slackBot: SlackBot) {
        slackBot.on(pong.self, service: self) { [unowned self] bot, pong in
            guard Double(pong.timestamp - self.lastExecuted) >= self.interval else { return }

            self.lastExecuted = pong.timestamp
            try self.action(bot, pong)
        }
    }
}
