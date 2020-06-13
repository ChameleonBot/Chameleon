extension SlackAction {
    private struct Packet: Encodable {
        var channel: String
        var ts: String
    }
}

extension SlackAction {
    public static func delete(_ message: Message) -> SlackAction<Void> {
        let packet = Packet(channel: message.channel.rawValue, ts: message.$thread_ts ?? message.$ts ?? "-invalid-")
        return .init(name: "chat.delete", method: .post, packet: packet)
    }
}
