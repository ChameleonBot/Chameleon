
public struct UsersInfo: WebAPIRequest {
    public let id: String
    public let scopes: [WebAPI.Scope] = [.users_read]
    public let endpoint = "users.info"
    public var body: [String : Any?] {
        return ["user": id]
    }

    public init(id: String) {
        self.id = id
    }

    public func handle(response: NetworkResponse) throws -> User {
        guard
            let dictionary = response.jsonDictionary,
            let data = dictionary["user"] as? [String: Any]
            else { throw NetworkError.invalidResponse(response) }

        return try User(decoder: Decoder(data: data))
    }
}
