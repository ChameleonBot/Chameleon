import ChameleonKit
import Foundation

private struct ActiveRecording {
    var user: Identifier<User>
    var channel: Identifier<Channel>
    var listener: Cancellable?
    var packets: [[String: Any]]
}

extension SlackBot {
    public enum Recording { }
}

extension SlackBot.Recording {
    public struct Config {
        /// Will attempt to scrub (but maintain uniqueness) of object ids
        public var sanitize: Bool

        /// Defines the requirements of a User attempting to use the recording mechanism
        public var allowAccess: (User) -> Bool

        public static func `default`() -> Config {
            return .init(sanitize: true, allowAccess: { $0.is_admin })
        }
    }
}

extension SlackBot {
    public func enableRecording(config: Recording.Config) -> SlackBot {
        var currentRecording: ActiveRecording?

        listen(for: .message) { bot, messsage in
            try messsage.richText().matching([^.user(bot.me), "start recording"]) {
                let user = try bot.lookup(messsage.user)
                guard config.allowAccess(user) else { return }

                guard currentRecording == nil else {
                    try bot.perform(.respond(to: messsage, .inline, with: "There's already an active recording"))
                    return
                }

                currentRecording = ActiveRecording(user: messsage.user, channel: messsage.channel, listener: nil, packets: [])
                try bot.perform(.respond(to: messsage, .inline, with: "Recording started"))
                currentRecording?.listener = bot.listen(for: .rawMessage(messsage.channel)) { bot, json in
                    currentRecording?.packets.append(json)
                }
            }

            try messsage.richText().matching([^.user(bot.me), "stop recording"]) {
                guard let recording = currentRecording, recording.user == messsage.user else { return }

                guard recording.channel == messsage.channel else {
                    try bot.perform(.respond(to: messsage, .inline, with: "There's no active recording here"))
                    return
                }

                let packets = config.sanitize
                    ? Recording.sanitize(bot: bot.me, recording.packets)
                    : recording.packets

                recording.listener?.cancel()
                currentRecording = nil

                if packets.isEmpty {
                    try bot.perform(.respond(to: messsage, .inline, with: "Recording stopped, nothing recorded"))

                } else {
                    let string = try packets
                        .map { packet -> String in
                            let data = try JSONSerialization.data(withJSONObject: packet, options: .prettyPrinted)
                            return String(data: data, encoding: .utf8)!
                    }
                    .joined(separator: "\n")

                    try bot.perform(.respond(to: messsage, .inline, with: "Recording stopped, recorded \(packets.count) messages."))
                    try bot.perform(.upload(channels: [messsage.channel], filetype: .javascript, Data(string.utf8)))
                }
            }
        }

        return self
    }
}
