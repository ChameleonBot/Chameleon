
public extension MessageDecorator {
    public enum Error: Swift.Error {
        case unableToFind(value: String)
    }
}

public struct MessageDecorator {
    // MARK: - Public Properties
    public let message: Message

    // MARK: - Lifecycle
    init(message: Message) {
        self.message = message
    }
}

public extension Message {
    func makeDecorator() -> MessageDecorator {
        return MessageDecorator(message: self)
    }
}
