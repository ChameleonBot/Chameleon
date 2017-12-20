
public struct ChatMessage {
    public let channel: String
    public let text: String

    public let parse: Parse?
    public let link_names: Bool?
    public let unfurl_links: Bool?

    public let unfurl_media: Bool?

    public let username: String?
    public let as_user: Bool?

    public let icon_url: String?
    public let icon_emoji: String?

    public let thread_ts: String?
    public let reply_broadcast: Bool?

    public let attachments: [Attachment]

    public init(
        channel: String,
        text: String,
        parse: Parse? = nil,
        link_names: Bool? = nil,
        unfurl_links: Bool? = nil,
        unfurl_media: Bool? = nil,
        username: String? = nil,
        as_user: Bool? = nil,
        icon_url: String? = nil,
        icon_emoji: String? = nil,
        thread_ts: String? = nil,
        reply_broadcast: Bool? = nil,
        attachments: [Attachment] = []
        )
    {
        self.channel = channel
        self.text = text
        self.parse = parse
        self.link_names = link_names
        self.unfurl_links = unfurl_links
        self.unfurl_media = unfurl_media
        self.username = username
        self.as_user = as_user
        self.icon_url = icon_url
        self.icon_emoji = icon_emoji
        self.thread_ts = thread_ts
        self.reply_broadcast = reply_broadcast
        self.attachments = attachments
    }
}

extension ChatMessage: Common.Encodable {
    public func encode() -> [String: Any?] {
        return [
            "channel": channel,
            "text": text,
            "parse": parse?.rawValue,
            "link_names": link_names,
            "unfurl_links": unfurl_links,
            "unfurl_media": unfurl_media,
            "username": username,
            "as_user": as_user,
            "icon_url": icon_url,
            "icon_emoji": icon_emoji,
            "thread_ts": thread_ts,
            "reply_broadcast": reply_broadcast,
            "attachments": attachments.map { $0.encode() },
            ]
    }
}
