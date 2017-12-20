
struct UserFromBotRequest: WebAPIRequest {
    private let innerRequest = RawUsersList()
    private let bot_id: String

    var url: String { return innerRequest.url }
    var endpoint: String { return innerRequest.endpoint }
    var body: [String: Any?] { return innerRequest.body }
    var scopes: [WebAPI.Scope] { return innerRequest.scopes }
    var authenticated: Bool { return innerRequest.authenticated }

    init(bot_id: String) {
        self.bot_id = bot_id
    }

    func handle(response: NetworkResponse) throws -> User {
        let users = try innerRequest.handle(response: response)

        func isTarget(_ json: [String: Any]) -> Bool {
            guard
                let profile = json["profile"] as? [String: Any],
                let botid = profile["bot_id"] as? String,
                botid == bot_id
                else { return false }

            return true
        }

        guard let user = users.first(where: isTarget)
            else { throw Error.botNotFound }

        return try User(decoder: Decoder(data: user))
    }
}

public struct RawUsersList: WebAPIRequest {
    public let endpoint = "users.list"
    public let scopes: [WebAPI.Scope] = [.users_read]

    public init() { }

    public func handle(response: NetworkResponse) throws -> [[String: Any]] {
        guard
            let dictionary = response.jsonDictionary,
            let data = dictionary["members"] as? [[String: Any]]
            else { throw NetworkError.invalidResponse(response) }

        return data
    }
}

extension UserFromBotRequest {
    enum Error: Swift.Error {
        case botNotFound
    }
}
