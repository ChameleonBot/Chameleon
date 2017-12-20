
public protocol WebAPIAuthenticator {
    func token<T: WebAPIRequest>(for method: T) throws -> String
}
