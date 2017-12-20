
final class ConversationService<Segment: ConversationSegment, State>: SlackBotMessageService {
    // MARK: - Private Properties
    private var activeConversations: [ActiveConversation<Segment, State>] = []

    // MARK: - Internal Functions
    func start(conversation: Conversation<Segment, State>, on segment: Segment, in message: MessageDecorator, using slackBot: SlackBot) throws {
        guard !activeConversations.contains(where: { $0.conversing(with: message) }) else { return }

        let activeConversation = ActiveConversation<Segment, State>(
            with: conversation,
            in: message,
            completed: { [unowned self] convo, state in
                conversation.completion?(message, state)
                self.activeConversations = self.activeConversations.filter { $0 !== convo }
            },
            cancelled: { [unowned self] convo in
                conversation.cancellation?(message)
                self.activeConversations = self.activeConversations.filter { $0 !== convo }
            }
        )
        activeConversations.append(activeConversation)

        try activeConversation.start(with: segment, in: message, using: slackBot)
    }
    func onMessage(slackBot: SlackBot, message: MessageDecorator, previous: MessageDecorator?) throws {
        let conversations = activeConversations.filter { $0.conversing(with: message) }

        for conversation in conversations {
            try conversation.execute(with: message, using: slackBot)
        }
    }
}
