
public struct IMList: WebAPIRequest {
    public let endpoint = "im.list"

    public func handle(response: NetworkResponse) throws -> [IM] {
        guard
            let dictionary = response.jsonDictionary,
            let data = dictionary["ims"] as? [[String: Any]]
            else { throw NetworkError.invalidResponse(response) }

        return try data.compactMap { try IM(decoder: Decoder(data: $0)) }
    }
}
