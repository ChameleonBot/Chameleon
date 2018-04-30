import Foundation

public final class WebAPI {
    // MARK: - Private Properties
    private let network: Network
    private var authenticator: WebAPIAuthenticator?

    // MARK: - Lifecycle
    public init(network: Network) {
        self.network = network

        network.register(
            middleware: [
                HTTPStatusCodeMiddleware(),
                WebAPIMiddleware(),
            ]
        )
    }

    // MARK: - Public
    public func use(authenticator: WebAPIAuthenticator?) {
        self.authenticator = authenticator
    }
    public func perform<T: WebAPIRequest>(request: T) throws -> T.Result {
        do {
            let networkRequest = try request
                .signed(with: self.authenticator)
                .addCommonHeaders()

            let response = try network.perform(
                request: networkRequest,
                middleware: [RetryMiddleware(maxRetries: 3)]
            )

            return try request.handle(response: response)

        } catch NetworkRequestError.error(_, let error) {
            let unsigned = request.unsigned().addCommonHeaders()

            throw RequestError.error(
                type: T.self,
                error: NetworkRequestError.error(request: unsigned, error: error)
            )

        } catch let error {
            throw RequestError.error(type: T.self, error: error)
        }
    }
}

private extension Dictionary where Value: OptionalType {
    func encoded(with encoding: Encoding) -> Data? {
        switch encoding {
        case .form: return strippingNils().urlEncoded()
        case .json: return strippingNils().jsonEncoded()
        }
    }
}
private extension Dictionary {
    func urlEncoded() -> Data? {
        // borrowed from Moya
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        return self
            .map { ($0.key, "\($0.value)".addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)) }
            .filter { $0.1 != nil }
            .map { "\($0)=\($1!)" }
            .joined(separator: "&")
            .data(using: .utf8, allowLossyConversion: false)
    }
    func jsonEncoded() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [])
    }
}

private extension WebAPIRequest {
    func unsigned() -> NetworkRequest {
        return NetworkRequest(
            method: .POST,
            url: url,
            headers: [:],
            body: body.encoded(with: encoding)
        )
    }
    func signed(with authenticator: WebAPIAuthenticator?) throws -> NetworkRequest {
        var request = unsigned()

        guard authenticated else { return request }

        guard let authenticator = authenticator else { throw WebAPI.Error.authenticationRequired }

        let signedBody = body + ["token": try authenticator.token(for: self)]
        request.body = signedBody.encoded(with: encoding)
        return request
    }
}

private extension NetworkRequest {
    func addCommonHeaders() -> NetworkRequest {
        let common: [String: LosslessStringConvertible] = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept" : "application/json",
        ]

        return NetworkRequest(
            method: method,
            url: url,
            headers: common + headers,
            body: body
        )
    }
}
