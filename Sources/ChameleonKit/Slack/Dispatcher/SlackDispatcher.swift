/// Acts as a single object for performing actions on Slack
public protocol SlackDispatcher {
    func perform<T>(_ action: SlackAction<T>) throws -> T
}
