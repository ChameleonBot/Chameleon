
struct IMFromListRequest: WebAPIRequest {
    private let innerRequest = RawIMList()
    private let id: String

    var url: String { return innerRequest.url }
    var endpoint: String { return innerRequest.endpoint }
    var body: [String: Any?] { return innerRequest.body }
    var scopes: [WebAPI.Scope] { return innerRequest.scopes }
    var authenticated: Bool { return innerRequest.authenticated }

    init(id: String) {
        self.id = id
    }

    func handle(response: NetworkResponse) throws -> IM {
        let ims = try innerRequest.handle(response: response)

        guard let im = ims.first(where: { ($0["id"] as? String) == id })
            else { throw Error.imNotFound }

        return try IM(decoder: Decoder(data: im))
    }
}

public struct RawIMList: WebAPIRequest {
    public let endpoint = "im.list"

    public func handle(response: NetworkResponse) throws -> [[String: Any]] {
        guard
            let dictionary = response.jsonDictionary,
            let data = dictionary["ims"] as? [[String: Any]]
            else { throw NetworkError.invalidResponse(response) }

        return data
    }
}

extension IMFromListRequest {
    enum Error: Swift.Error {
        case imNotFound
    }
}
