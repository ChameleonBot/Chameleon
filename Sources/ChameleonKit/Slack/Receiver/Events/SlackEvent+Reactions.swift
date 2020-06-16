public struct ReactionEvent: Codable, Equatable {
    public var user: Identifier<User>
    public var reaction: Emoji

    public var item_user: Identifier<User>?

//    TODO
//        "item": {
//            "type": "message",
//            "channel": "C0G9QF9GZ",
//            "ts": "1360782400.498405"
//        },
//    }
}

extension SlackEvent {
    public static var reactionAdd: SlackEvent<ReactionEvent> {
        return .init(identifier: "reaction_added", type: "reaction_added")
    }
}

extension SlackEvent {
    public static var reactionRemove: SlackEvent<ReactionEvent> {
        return .init(identifier: "reaction_removed", type: "reaction_removed")
    }
}
