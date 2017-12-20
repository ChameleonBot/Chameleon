
/// Wraps a `WebAPIRequest` into a generic struct
public struct ModelWebAPIRequest<Model>: WebAPIRequest {
    public let url: String
    public let endpoint: String
    public let body: [String: Any?]
    public let scopes: [WebAPI.Scope]
    public let authenticated: Bool

    let _handle: (NetworkResponse) throws -> Model

    public init<T: WebAPIRequest>(request: T) where T.Result == Model {
        self.url = request.url
        self.endpoint = request.endpoint
        self.body = request.body
        self.scopes = request.scopes
        self.authenticated = request.authenticated
        self._handle = request.handle
    }

    public func handle(response: NetworkResponse) throws -> Model {
        return try _handle(response)
    }
}
