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
    public static func update(_ interaction: Interaction, with markdown: MarkdownString) -> SlackAction<Void> {
        return update(channel: interaction.channel, message_ts: interaction.message_ts ?? "-invalid-", with: markdown)
    }
    public static func update(_ message: Message, with markdown: MarkdownString) -> SlackAction<Void> {
        return update(channel: message.channel, message_ts: message.$thread_ts ?? message.$ts ?? "-invalid-", with: markdown)
    }

    private static func update(channel: Identifier<Channel>, message_ts: String, with markdown: MarkdownString) -> SlackAction<Void> {
        let packet = TextPacket(channel: channel.rawValue, ts: message_ts, text: markdown.value)

        return .init(name: "chat.update", method: .post, packet: packet)
    }
}

extension SlackAction {
    public static func update(_ interaction: Interaction, with blocks: [LayoutBlockBuilder<MessagesSurface>]) -> SlackAction<Void> {
        return update(channel: interaction.channel, message_ts: interaction.message_ts ?? "-invalid-", with: blocks)
    }
    public static func update(_ message: Message, with blocks: [LayoutBlockBuilder<MessagesSurface>]) -> SlackAction<Void> {
        return update(channel: message.channel, message_ts: message.$thread_ts ?? message.$ts ?? "-invalid-", with: blocks)
    }

    private static func update(channel: Identifier<Channel>, message_ts: String, with blocks: [LayoutBlockBuilder<MessagesSurface>]) -> SlackAction<Void> {
        let packet = BlockPacket(channel: channel.rawValue, ts: message_ts, blocks: blocks.map { $0.build() })

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
