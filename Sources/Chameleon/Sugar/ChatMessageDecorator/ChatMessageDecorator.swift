
public final class ChatMessageDecorator {
    // MARK: - Private Properties
    private let target: TargetRepresentable

    // MARK: - Internal Properties
    var text: String = ""
    var as_user = true
    var attachments: [Attachment] = []

    // MARK: - Lifecycle
    init(target: TargetRepresentable) {
        self.target = target
    }

    // MARK: - Public
    public func makeChatMessage() throws -> ChatMessage {
        return ChatMessage(
            channel: try target.targetId(),
            text: text,
            as_user: as_user,
            thread_ts: target.targetThread_ts,
            attachments: attachments
        )
    }
}
