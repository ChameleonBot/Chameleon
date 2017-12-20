
extension SlackBot {
    /// Subscribes to an `RTMAPIEvent`
    ///
    /// - Parameters:
    ///   - event: The `RTMAPIEvent` to subscribe to
    ///   - handler: The function called when the event occurs. Provides the bot instance and the events data
    public func on<T: RTMAPIEvent>(_ event: T.Type, handler: @escaping (SlackBot, T.EventData) throws -> Void) {
        rtmApi.on(event) { [unowned self] data in
            try handler(self, data)
        }
    }
}
