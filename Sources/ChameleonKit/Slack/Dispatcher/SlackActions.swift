import Foundation

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
    private struct TextPacket: Encodable {
        let channel: Identifier<Channel>
        let text: String
    }
    public static func speak(in channel: Identifier<Channel>, _ text: String) -> SlackAction<Void> {
        let packet = TextPacket(channel: channel, text: text)
        return .init(name: "chat.postMessage", method: .post, packet: packet)
    }
}

extension SlackAction {
    public static var authDetails: SlackAction<AuthenticationDetails> {
        return .init(name: "auth.test", method: .get)
    }
}
