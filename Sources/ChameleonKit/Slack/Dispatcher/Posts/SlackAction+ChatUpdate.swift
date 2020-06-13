extension SlackAction {
    private struct TextPacket: Encodable {
        var channel: String
        var ts: String
        var text: String
    }
    private struct BlockPacket: Encodable {
        var channel: String
        var ts: String
        @ManyOf<LayoutBlocks> var blocks: [LayoutBlock]
    }
}

extension SlackAction {
    public static func update(_ message: Message, with markdown: MarkdownString) -> SlackAction<Void> {
        let packet = TextPacket(channel: message.channel.rawValue, ts: message.$thread_ts ?? message.$ts ?? "-invalid-", text: markdown.value)

        return .init(name: "chat.update", method: .post, packet: packet)
    }

    public static func update(_ message: Message, with blocks: [LayoutBlockBuilder<MessagesSurface>]) -> SlackAction<Void> {
        let packet = BlockPacket(channel: message.channel.rawValue, ts: message.$thread_ts ?? message.$ts ?? "-invalid-", blocks: blocks.map { $0.build() })

        return .init(
            name: "chat.update",
            method: .post,
            packet: packet,
            setup: { receiver in
                blocks.forEach { $0.setup(receiver) }
            }
        )
    }
}
