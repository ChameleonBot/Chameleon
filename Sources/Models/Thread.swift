
public struct Thread {
    public let ts: String
    public let thread_ts: String
    public let replies: [ThreadReply]
    public let channel: ModelPointer<Channel>?
    public let im: ModelPointer<IM>?
}

public struct ThreadReply {
    public let user: ModelPointer<User>
    public let ts: String
}

extension Thread: Common.Decodable {
    public init(decoder: Common.Decoder) throws {
        self = try decode {
            return Thread(
                ts: try decoder.value(at: ["ts"]),
                thread_ts: try decoder.value(at: ["thread_ts"]),
                replies: (try? decoder.values(at: ["replies"])) ?? [],
                channel: channelPointer(from: decoder),
                im: imPointer(from: decoder)
            )
        }
    }
}

extension ThreadReply: Common.Decodable {
    public init(decoder: Common.Decoder) throws {
        self = try decode {
            return ThreadReply(
                user: try decoder.pointer(at: ["user"]),
                ts: try decoder.value(at: ["ts"])
            )
        }
    }
}
