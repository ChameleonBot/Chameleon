
public final class ChatMessageDecorator {
    // MARK: - Private Properties
    private let target: TargetRepresentable?
    private let response_url: String?
    
    // MARK: - Internal Properties
    var text: String = ""
    var as_user = true
    var attachments: [Attachment] = []

    // MARK: - Lifecycle
    init(target: TargetRepresentable) {
        self.target = target
        self.response_url = nil
    }
    public init(response_url: String) {
        self.target = nil
        self.response_url = response_url
    }
    
    // MARK: - Public
    public func makeChatMessage() throws -> ChatMessage {
        if let target = target {
            return ChatMessage(
                channel: try target.targetId(),
                text: text,
                as_user: as_user,
                thread_ts: target.targetThread_ts,
                attachments: attachments
            )
            
        } else if let response_url = response_url {
            return ChatMessage(
                response_url: response_url,
                text: text,
                as_user: as_user,
                attachments: attachments
            )
            
        } else {
            fatalError("Invalid state")
        }
    }
}
