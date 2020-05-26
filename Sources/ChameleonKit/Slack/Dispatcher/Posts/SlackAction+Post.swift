public struct ResponseTarget {
    let target: (Message) -> (channel: String, thread_ts: String?)
}

extension ResponseTarget {
    public static var inline: ResponseTarget {
        return .init { message in
            return (channel: message.channel.rawValue, thread_ts: message.$thread_ts)
        }
    }

    public static var threaded: ResponseTarget {
        return .init { message in
            if message.threading == .threaded {
                return inline.target(message)
            } else {
                return (channel: message.channel.rawValue, thread_ts: message.$ts)
            }
        }
    }
}

extension SlackAction {
    private struct TextPacket: Encodable {
        var channel: String
        var thread_ts: String?
        var text: String
        var mrkdwn = true
    }
    private struct BlockPacket: Encodable {
        var channel: String
        var thread_ts: String?
        @ManyOf<LayoutBlocks> var blocks: [LayoutBlock]
    }
}

extension SlackAction {
    public static func respond(to message: Message, _ target: ResponseTarget, with markdown: MarkdownString) -> SlackAction<Message> {
        let target = target.target(message)
        let packet = TextPacket(channel: target.channel, thread_ts: target.thread_ts, text: markdown.value)

        return .init(name: "chat.postMessage", method: .post, packet: packet) { packet -> Message in
            var packet = packet
            packet.squash(from: "message")
            return try Message(from: packet)
        }
    }
    public static func respond(to message: Message, _ target: ResponseTarget, with blocks: [LayoutBlockBuilder<MessagesSurface>]) -> SlackAction<Message> {
        let target = target.target(message)
        let packet = BlockPacket(channel: target.channel, thread_ts: target.thread_ts, blocks: blocks.map { $0.build() })
        return .init(name: "chat.postMessage", method: .post, packet: packet)
    }
}

extension SlackAction {
    public static func speak(in channel: Identifier<Channel>, _ markdown: MarkdownString) -> SlackAction<Void> {
        let packet = TextPacket(channel: channel.rawValue, text: markdown.value)
        return .init(name: "chat.postMessage", method: .post, packet: packet)
    }

    public static func speak(in channel: Identifier<Channel>, blocks: [LayoutBlockBuilder<MessagesSurface>]) -> SlackAction<Void> {
        let packet = BlockPacket(channel: channel.rawValue, blocks: blocks.map { $0.build() })
        return .init(name: "chat.postMessage", method: .post, packet: packet)
    }
}
