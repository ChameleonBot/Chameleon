
public struct GroupsInfo: WebAPIRequest {
    public let id: String

    public let endpoint = "groups.info"
    public var body: [String : Any?] {
        return ["channel": id]
    }

    public init(id: String) {
        self.id = id
    }

    public func handle(response: NetworkResponse) throws -> Group {
        guard
            let dictionary = response.jsonDictionary,
            let data = dictionary["group"] as? [String: Any]
            else { throw NetworkError.invalidResponse(response) }

        return try Group(decoder: Decoder(data: data))
    }
}
