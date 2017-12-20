
public struct ChannelsInfo: WebAPIRequest {
    public let id: String

    public let endpoint = "channels.info"
    public var body: [String : Any?] {
        return ["channel": id]
    }

    public init(id: String) {
        self.id = id
    }

    public func handle(response: NetworkResponse) throws -> Channel {
        guard
            let dictionary = response.jsonDictionary,
            let data = dictionary["channel"] as? [String: Any]
            else { throw NetworkError.invalidResponse(response) }

        return try Channel(decoder: Decoder(data: data))
    }
}
