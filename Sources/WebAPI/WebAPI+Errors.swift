
extension WebAPI {
    public enum Error: Swift.Error {
        case authenticationRequired
    }

    public enum RequestError<T: WebAPIRequest>: Swift.Error, CustomStringConvertible {
        case error(type: T.Type, error: Swift.Error)

        public var description: String {
            switch self {
            case .error(let type, let error):
                return "\(String(reflecting: type)): \(String(describing: error))"
            }
        }
    }
}
