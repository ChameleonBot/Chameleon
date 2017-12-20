
public protocol ReactionTarget {
    func encoded() -> [String: Any?]
}

public struct ReactionsAdd: WebAPIRequest {
    public let scopes: [WebAPI.Scope] = [.reactions_write]
    public let endpoint = "reactions.add"
    public var body: [String : Any?] {
        let emojiValue = emoji.emoji.remove(prefix: ":").substring(until: [":"])
        return target.encoded().appending(["name": emojiValue])
    }

    private let emoji: EmojiRepresentable
    private let target: ReactionTarget

    public init<T: EmojiRepresentable, U: ReactionTarget>(emoji: T, target: U) {
        self.emoji = emoji
        self.target = target
    }

    public func handle(response: NetworkResponse) throws -> Void {
        //
    }
}

public struct ChannelReaction: ReactionTarget {
    public let id: String
    public let messageTs: String

    public init(id: String, messageTs: String) {
        self.id = id
        self.messageTs = messageTs
    }

    public func encoded() -> [String: Any?] {
        return ["channel": id, "timestamp": messageTs]
    }
}
