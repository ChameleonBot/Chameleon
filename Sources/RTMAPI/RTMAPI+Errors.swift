
extension RTMAPI {
    public enum EventError<T: RTMAPIEvent>: Error, CustomStringConvertible {
        case error(type: T.Type, error: Error)

        public var description: String {
            switch self {
            case .error(let type, let error):
                return "\(String(reflecting: type)): \(String(describing: error))"
            }
        }
    }
}
