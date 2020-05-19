import Foundation

extension SlackAction {
    public static var authDetails: SlackAction<AuthenticationDetails> {
        return .init(name: "auth.test", method: .get)
    }
}

extension SlackAction {
    private struct UserPacket: Encodable {
        let include_locale: Bool
        let user: Identifier<User>
    }

    public static func user(_ identifier: Identifier<User>, include_locale: Bool = true) -> SlackAction<User> {
        let packet = UserPacket(include_locale: include_locale, user: identifier)
        return .init(name: "users.info", method: .post, encoding: .url, packet: packet)
    }
}

extension SlackAction {
    private struct ChannelPacket: Encodable {
        let channel: Identifier<Channel>
    }

    public static func channel(_ identifier: Identifier<Channel>) -> SlackAction<Channel> {
        let packet = ChannelPacket(channel: identifier)
        return .init(name: "conversations.info", method: .post, encoding: .url, packet: packet)
    }
}

extension SlackAction {
    private struct ReactionPacket: Encodable {
        let name: String
        let channel: Identifier<Channel>
        let timestamp: String
    }

    public static func react(to message: Message, with emoji: Emoji) -> SlackAction<Void> {
        let packet = ReactionPacket(name: emoji.rawValue, channel: message.channel, timestamp: message.$ts ?? message.channel.rawValue)
        return .init(name: "reactions.add", method: .post, packet: packet)
    }
}

extension SlackAction {
    private struct PermalinkPacket: Encodable {
        let channel: Identifier<Channel>
        let message_ts: String
    }
    public static func permalink(for message: Message) -> SlackAction<Permalink> {
        let message_ts = message.$ts ?? message.channel.rawValue
        let packet = PermalinkPacket(channel: message.channel, message_ts: message_ts)
        return .init(name: "chat.getPermalink", method: .post, encoding: .url, packet: packet)
    }
}
