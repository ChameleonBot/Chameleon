
extension ActiveConversation {
    enum Error: Swift.Error {
        case invalidStatus(String)
        case unexpected(String)
    }
}

extension ActiveConversation {
    indirect enum Status {
        case pending // nothing has happened
        case start(Segment) // a segment was activated
        case input(Segment) // a segment received input
        case stopped // nothing more can happen
    }
}

class ActiveConversation<Segment: ConversationSegment, State> {
    public typealias CompletionHandler = (ActiveConversation<Segment, State>, State) -> Void
    public typealias CancellationHandler = (ActiveConversation<Segment, State>) -> Void

    // MARK: - Private Properties
    private let conversation: Conversation<Segment, State>
    private let message: MessageDecorator
    private var state: State
    private var status: Status

    // MARK: - Internal Properties
    let completed: CompletionHandler
    let cancelled: CancellationHandler

    // MARK: - Lifecycle
    init(
        with conversation: Conversation<Segment, State>,
        in message: MessageDecorator,
        completed: @escaping CompletionHandler,
        cancelled: @escaping CancellationHandler
        )
    {
        self.conversation = conversation
        self.status = .pending
        self.message = message
        self.completed = completed
        self.cancelled = cancelled
        self.state = conversation.stateFactory()
    }

    // MARK: - Internal Functions
    func conversing(with message: MessageDecorator) -> Bool {
        return self.message.identifier == message.identifier
    }
    func start(with segment: Segment, in message: MessageDecorator, using slackBot: SlackBot) throws {
        switch status {
        case .pending:
            status = .start(segment)
            try execute(with: message, using: slackBot)

        default:
            throw Error.invalidStatus("Conversation must be pending to start")
        }
    }
    func execute(with message: MessageDecorator, using slackBot: SlackBot) throws {
        switch status {
        case .pending:
            throw Error.invalidStatus("Conversation must have been started to execute")

        case .start(let segment):
            try send(text: segment.message, to: message, using: slackBot)
            status = .input(segment)

        case .input(let segment):
            //we don't want the trigger interfering with the conversation
            guard message.message.ts != self.message.message.ts else { return }

            guard let handler = conversation.events[segment]
                else { throw Error.unexpected("Segment without a handler") }

            if let match = message.text.patternMatch(against: segment.input) {
                var state = self.state
                let event = try handler(message, match, &state)
                self.state = state

                switch event {
                case .next(let segment):
                    status = .start(segment)
                    try execute(with: message, using: slackBot)

                case .retry(let response):
                    try send(text: response, to: message, using: slackBot)
                    try execute(with: message, using: slackBot)

                case .cancel(let response):
                    status = .stopped
                    cancelled(self)
                    try send(text: response, to: message, using: slackBot)

                case .complete(let response):
                    status = .stopped
                    completed(self, self.state)
                    try send(text: response, to: message, using: slackBot)
                }

            } else {
                let response = try message
                    .respond()
                    .text(["Sorry, I didn't understand you..."])
                    .newLine()
                    .text(["I'm looking for something like:"])
                    .newLine()
                    .text([patternDescription(segment.input).pre])

                try slackBot.send(response.makeChatMessage())
            }

        case .stopped:
            break // do nothing
        }
    }

    // MARK: - Private Functions
    private func send(text: [ChatMessageSegmentRepresentable], to message: MessageDecorator, using slackBot: SlackBot) throws {
        guard !text.isEmpty else { return }

        try slackBot.send(text, to: message.target())
    }
}

extension ActiveConversation: Equatable {
    var identifier: String {
        return "\(Segment.self):\(State.self)"
    }

    static func ==(lhs: ActiveConversation, rhs: ActiveConversation) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

private extension MessageDecorator {
    var identifier: String {
        return try! [self.targetId(), self.sender().id].joined(separator: ":")
    }
}
