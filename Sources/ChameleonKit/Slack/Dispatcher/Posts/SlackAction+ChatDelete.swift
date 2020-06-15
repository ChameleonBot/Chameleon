extension SlackAction {
    private struct Packet: Encodable {
        var channel: String
        var ts: String
    }
}

extension SlackAction {
    public static func delete(_ interaction: Interaction) -> SlackAction<Void> {
        return delete(channel: interaction.channel, ts: interaction.message_ts ?? "-invalid-")
    }
    public static func delete(_ message: Message) -> SlackAction<Void> {
        return delete(channel: message.channel, ts: message.$thread_ts ?? message.$ts ?? "-invalid-")
    }

    private static func delete(channel: Identifier<Channel>, ts: String) -> SlackAction<Void> {
        let packet = Packet(channel: channel.rawValue, ts: ts)
        return .init(name: "chat.delete", method: .post, packet: packet)
    }
}
