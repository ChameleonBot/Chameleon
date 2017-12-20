
struct BotFromUserRequest: WebAPIRequest {
    private let innerRequest: UsersInfo

    var url: String { return innerRequest.url }
    var endpoint: String { return innerRequest.endpoint }
    var body: [String: Any?] { return innerRequest.body }
    var scopes: [WebAPI.Scope] { return innerRequest.scopes }
    var authenticated: Bool { return innerRequest.authenticated }

    init(id: String) {
        innerRequest = UsersInfo(id: id)
    }

    func handle(response: NetworkResponse) throws -> BotUser {
        let user = try innerRequest.handle(response: response)

        guard user.is_bot else { throw Error.notABot }

        return BotUser(id: user.id, name: user.name)
    }
}

extension BotFromUserRequest {
    enum Error: Swift.Error {
        case notABot
    }
}
