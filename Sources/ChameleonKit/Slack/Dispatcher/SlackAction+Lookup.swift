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
	private struct ConversationPacket: Encodable {
		let channel: Identifier<Channel>
	}

	public static func conversation(_ identifier: Identifier<Channel>) -> SlackAction<Conversation> {
		let packet = ConversationPacket(channel: identifier)
		return .init(name: "conversations.info", method: .post, encoding: .url, packet: packet)
	}
}
