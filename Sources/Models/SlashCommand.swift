
public struct SlashCommand {
    public let token: String
    public let team_id: ModelPointer<Team>
    public let team_domain: String
    public let channel_id: ModelPointer<Channel>
    public let channel_name: String
    public let user_id: ModelPointer<User>
    public let user_name: String
    public let command: String
    public let text: String
    public let response_url: String
}

extension SlashCommand: Common.Decodable {
    public init(decoder: Common.Decoder) throws {
        self = try decode {
            return SlashCommand(
                token: try decoder.value(at: ["token"]),
                team_id: try decoder.pointer(at: ["team_id"]),
                team_domain: try decoder.value(at: ["team_domain"]),
                channel_id: try decoder.pointer(at: ["channel_id"]),
                channel_name: try decoder.value(at: ["channel_name"]),
                user_id: try decoder.pointer(at: ["user_id"]),
                user_name: try decoder.value(at: ["user_name"]),
                command: try decoder.value(at: ["command"]),
                text: (try? decoder.value(at: ["text"])) ?? "",
                response_url: try decoder.value(at: ["response_url"])
            )
        }
    }
}
