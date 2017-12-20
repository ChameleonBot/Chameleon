
public struct UsersList: WebAPIRequest {
    public let endpoint = "users.list"
    public let scopes: [WebAPI.Scope] = [.users_read]

    public init() { }

    public func handle(response: NetworkResponse) throws -> [User] {
        guard
            let dictionary = response.jsonDictionary,
            let data = dictionary["members"] as? [[String: Any]]
            else { throw NetworkError.invalidResponse(response) }

        return try data.map { try User(decoder: Decoder(data: $0)) }
    }
}
