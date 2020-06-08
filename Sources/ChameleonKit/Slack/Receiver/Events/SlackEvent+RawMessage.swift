extension SlackEvent {
    public static var rawMessage: SlackEvent<[String: Any]> {
        return .init(
            identifier: "rawMessage",
            canHandle: { type, json in type == "message" },
            handler: { $0 }
        )
    }

    public static func rawMessage(_ channel: Identifier<Channel>) -> SlackEvent<[String: Any]> {
        return .init(
            identifier: "rawMessage_filtered",
            canHandle: { type, json in
                return type == "message" && (json["channel"] as? String) == channel.rawValue
            },
            handler: { $0 }
        )
    }
}
