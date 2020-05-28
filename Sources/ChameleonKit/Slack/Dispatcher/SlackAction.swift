import Foundation

public struct SlackAction<Value> {
    public typealias Handler = ([String: Any]) throws -> Value

    public enum Method {
        case post, get
    }
    public enum Encoding {
        case json, url, formData
    }

    public let name: String
    public let method: Method
    public let encoding: Encoding
    public let packet: Encodable?
    public let handle: Handler

    public init(name: String, method: Method, encoding: Encoding = .json, packet: Encodable? = nil, handler: @escaping Handler) {
        self.name = name
        self.method = method
        self.encoding = encoding
        self.packet = packet
        self.handle = { packet in
            if let error = try? SlackError(from: packet) {
                throw error
            }
            return try handler(packet)
        }
    }
}

extension SlackAction where Value: Decodable {
    public init(name: String, method: Method, encoding: Encoding = .json, packet: Encodable? = nil) {
        self.init(name: name, method: method, encoding: encoding, packet: packet) { packet in
            do {
                return try Value(from: packet)
            } catch {
                return try Nested<Value>(from: packet).value
            }
        }
    }
}

extension SlackAction where Value == Void {
    public init(name: String, method: Method, encoding: Encoding = .json, packet: Encodable? = nil) {
        self.init(name: name, method: method, encoding: encoding, packet: packet) { _ in () }
    }
}
