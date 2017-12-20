
public extension MessageDecorator {
    var text: String { return message.text ?? "" }

    func sender() throws -> ModelPointer<User> {
        guard
            let value = message.user
                ?? message.edited?.user
                ?? message.bot_id.map({ ModelPointer<User>(id: $0.id) })
            else { throw Error.unableToFind(value: #function) }

        return value
        
    }
}
