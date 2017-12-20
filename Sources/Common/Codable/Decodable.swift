
public protocol Decodable {
    init(decoder: Decoder) throws
}

public enum DecodeError<T: Decodable>: Error, CustomStringConvertible {
    case error(type: T.Type, error: Error)

    public var description: String {
        switch self {
        case .error(let type, let error):
            return "\(String(reflecting: type)) > \(String(describing: error))"
        }
    }
}

public func decode<T: Decodable>(_ closure: () throws -> T) rethrows -> T {
    do { return try closure() }
    catch let error { throw DecodeError.error(type: T.self, error: error) }
}
