
public class Conversation<Segment: ConversationSegment, State> {
    public typealias StateFactory = () -> State
    public typealias SegmentHandler = (MessageDecorator, PatternMatch, inout State) throws -> Event
    public typealias CompletionHandler = (MessageDecorator, State) -> Void
    public typealias CancellationHandler = (MessageDecorator) -> Void

    // MARK: - Internal Properties
    let stateFactory: StateFactory
    private(set) var events: [Segment: SegmentHandler] = [:]
    private(set) var completion: CompletionHandler?
    private(set) var cancellation: CancellationHandler?

    // MARK: - Lifecycle
    public init(initialState: @escaping StateFactory) {
        self.stateFactory = initialState
    }

    // MARK: - Public Functions
    @discardableResult public func on(_ segment: Segment, handler: @escaping SegmentHandler) -> Conversation {
        events[segment] = handler
        return self
    }
    @discardableResult public func onComplete(_ handler: @escaping CompletionHandler) -> Conversation {
        completion = handler
        return self
    }
    @discardableResult public func onCancel(_ handler: @escaping CancellationHandler) -> Conversation {
        cancellation = handler
        return self
    }
}

public extension SlackBot {
    func start<Segment, State>(conversation: Conversation<Segment, State>, in message: MessageDecorator, startingWith segment: Segment, whenMatching matchers: [Matcher]) throws {
        if !services.contains(where: { $0 is ConversationService<Segment, State> }) {
            let service = ConversationService<Segment, State>()
            service.configure(slackBot: self)
            add(service: service)
        }

        guard
            message.text.patternMatches(against: matchers),
            let service = services.lazy.flatMap({ $0 as? ConversationService<Segment, State> }).first
            else { return }

        try service.start(conversation: conversation, on: segment, in: message, using: self)
    }

    func start<Segment, State>(conversation: Conversation<Segment, State>, in message: MessageDecorator, startingWith segment: Segment, whenMatching pattern: PatternRepresentable) throws {
        try start(conversation: conversation, in: message, startingWith: segment, whenMatching: pattern.pattern)
    }
}
