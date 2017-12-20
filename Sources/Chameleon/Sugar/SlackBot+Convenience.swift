
public extension SlackBot {
    func send(_ message: ChatMessage) throws {
        let request = ChatPostMessage(message: message)
        try webApi.perform(request: request)
    }
    func send(_ text: [ChatMessageSegmentRepresentable], to target: TargetRepresentable) throws {
        let message = ChatMessageDecorator(target: target).text(text)
        try send(message.makeChatMessage())
    }

    func react<T: EmojiRepresentable>(to message: MessageDecorator, with emoji: T) throws {
        let target = ChannelReaction(id: try message.targetId(), messageTs: message.message.ts)
        let request = ReactionsAdd(emoji: emoji, target: target)
        try webApi.perform(request: request)
    }
}
