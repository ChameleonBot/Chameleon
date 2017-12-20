
import Dispatch
import Foundation

/// Defines behaviour to be applied when the bot is disconnected
public protocol ReconnectionStrategy: class {
    /// Returns `true` if the bot should reconnect, otherwise `false`
    func reconnect() -> Bool

    /// Resets any internal state related to this `ReconnectionStrategy`
    func reset()
}

/// Provides the default reconnection behaviour
public final class DefaultReconnectionStrategy: ReconnectionStrategy {
    public typealias Backoff = (Double) -> TimeInterval

    private let maxRetries: Int
    private var retries = 0
    private let backoff: Backoff

    private lazy var queue: DispatchQueue = DispatchQueue(label: String(describing: self))
    private let group = DispatchGroup()

    /// Create a new `DefaultReconnectionStrategy` instance
    ///
    /// - Parameters:
    ///   - maxRetries: The maximum number of times the bot will attempt to reconnect
    ///   - delay: A function that provides the retry count 
    ///            and returns the number of seconds to wait before the next connection attempt
    public init(maxRetries: Int, delay: @escaping Backoff) {
        self.maxRetries = maxRetries
        self.backoff = delay
    }

    public func reconnect() -> Bool {
        retries += 1

        guard retries <= maxRetries else { return false }

        group.enter()

        let delay = backoff(Double(retries))
        print("Waiting \(delay) seconds until reconnection")
        queue.asyncAfter(deadline: DispatchTime(secondsFromNow: delay), execute: group.leave)

        group.wait()

        return true
    }
    public func reset() {
        retries = 0
    }
}
