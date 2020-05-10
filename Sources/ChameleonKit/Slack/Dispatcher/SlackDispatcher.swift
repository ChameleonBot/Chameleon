/// Acts as a single object for performing actions on Slack
public protocol SlackDispatcher: AnyObject {
    func perform<T>(_ action: SlackAction<T>) throws -> T
}
