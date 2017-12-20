
public struct IMOpen: WebAPIRequest {
    public let userId: String

    public let endpoint = "im.open"
    public var body: [String : Any?] {
        return [
            "user": userId,
            "return_im": true,
        ]
    }

    public init(userId: String) {
        self.userId = userId
    }

    public func handle(response: NetworkResponse) throws -> IM {
        guard
            let dictionary = response.jsonDictionary,
            let data = dictionary["channel"] as? [String: Any]
            else { throw NetworkError.invalidResponse(response) }

        return try IM(decoder: Decoder(data: data))
    }
}
