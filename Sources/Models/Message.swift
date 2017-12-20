
public struct Message {
    public let text: String?
    public let ts: String
    public let subtype: Subtype?

    public let edited: MessageEdit?

    public let team: ModelPointer<Team>?
    public let user: ModelPointer<User>?
    public let channel: ModelPointer<Channel>?
    public let im: ModelPointer<IM>?
    public let thread: Thread?
    public let group: ModelPointer<Group>?
    public let bot_id: ModelPointer<BotUser>?
}

extension Message: Common.Decodable {
    public init(decoder: Common.Decoder) throws {
        self = try decode {
            return Message(
                text: try? decoder.value(at: ["text"]),
                ts: try decoder.value(at: ["ts"]),
                subtype: Message.Subtype(rawValue: (try? decoder.value(at: ["subtype"])) ?? ""),
                edited: try? decoder.value(at: ["edited"]),
                team: try? decoder.pointer(at: ["team"]),
                user: try? decoder.pointer(at: ["user"]),
                channel: channelPointer(from: decoder),
                im: imPointer(from: decoder),
                thread: try messageThread(from: decoder),
                group: groupPointer(from: decoder),
                bot_id: try? decoder.pointer(at: ["bot_id"])
            )
        }
    }
}
