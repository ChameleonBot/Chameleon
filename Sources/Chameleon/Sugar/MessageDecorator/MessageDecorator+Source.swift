
public extension MessageDecorator {
    var isChannel: Bool {
        return message.channel != nil
    }
    var isThread: Bool {
        return message.thread != nil
    }
    var isIM: Bool {
        return message.im != nil
    }
    var isGroup: Bool {
        return message.group != nil
    }
}
