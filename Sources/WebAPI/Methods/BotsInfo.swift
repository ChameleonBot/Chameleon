
public struct BotsInfo: WebAPIRequest {
    public let id: String
    public let scopes: [WebAPI.Scope] = [.users_read]
    public let endpoint = "bots.info"
    public var body: [String : Any?] {
        return ["bot": id]
    }

    public init(id: String) {
        self.id = id
    }

    public func handle(response: NetworkResponse) throws -> BotUser {
        guard
            let dictionary = response.jsonDictionary,
            let data = dictionary["bot"] as? [String: Any]
            else { throw NetworkError.invalidResponse(response) }

        return try BotUser(decoder: Decoder(data: data))
    }
}
