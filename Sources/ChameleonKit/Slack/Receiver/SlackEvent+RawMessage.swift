extension SlackEvent {
    public static func rawMessage(_ channel: Identifier<Channel>) -> SlackEvent<[String: Any]> {
        return .init(
            identifier: "rawMessage",
            canHandle: { $0 == "message" },
            handler: { $0 }
        )
    }
}
