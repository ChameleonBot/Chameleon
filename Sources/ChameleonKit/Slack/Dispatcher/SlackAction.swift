import Foundation

public struct SlackAction<Value> {
    public typealias Handler = (Data) throws -> Value

    public enum Method {
        case post, get
    }
    public enum Encoding {
        case json, url
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
        self.handle = handler
    }
}

extension SlackAction where Value: Decodable {
    public init(name: String, method: Method, encoding: Encoding = .json, packet: Encodable? = nil) {
        self.init(name: name, method: method, encoding: encoding, packet: packet) { data in
            do {
                return try JSONDecoder().decode(Value.self, from: data)
            } catch {
                return try JSONDecoder().decode(Nested<Value>.self, from: data).value
            }
        }
    }
}

extension SlackAction where Value == Void {
    public init(name: String, method: Method, encoding: Encoding = .json, packet: Encodable? = nil) {
        self.init(name: name, method: method, encoding: encoding, packet: packet) { _ in }
    }
}
