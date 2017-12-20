
public struct RTMConnect: WebAPIRequest {
    public let token: String
    public let endpoint = "rtm.connect"
    public var body: [String : Any?] {
        return ["token": token]
    }
    public let authenticated = false

    public init(token: String) {
        self.token = token
    }

    public func handle(response: NetworkResponse) throws -> SlackConnection {
        guard let data = response.jsonDictionary
            else { throw NetworkError.invalidResponse(response) }

        return try SlackConnection(decoder: Decoder(data: data))
    }
}

public struct SlackConnection {
    public let url: String
    public let team: Team
    public let bot: BotUser
}

extension SlackConnection: Common.Decodable {
    public init(decoder: Common.Decoder) throws {
        self = try decode {
            return SlackConnection(
                url: try decoder.value(at: ["url"]),
                team: try decoder.value(at: ["team"]),
                bot: try decoder.value(at: ["self"])
            )
        }
    }
}
