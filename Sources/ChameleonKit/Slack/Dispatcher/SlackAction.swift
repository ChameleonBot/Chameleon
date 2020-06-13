import Foundation

public struct SlackAction<Value> {
    public typealias Handler = ([String: Any]) throws -> Value
    public typealias Setup = (SlackReceiver) -> Void

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
    let setup: Setup

    public init(name: String, method: Method, encoding: Encoding = .json, packet: Encodable? = nil, setup closure: @escaping Setup = { _ in }, handler: @escaping Handler) {
        self.name = name
        self.method = method
        self.encoding = encoding
        self.packet = packet
        self.setup = closure
        self.handle = { packet in
            if let error = try? SlackAPIError(from: packet) {
                throw error
            }
            return try handler(packet)
        }
    }
}

extension SlackAction where Value: Decodable {
    public init(name: String, method: Method, encoding: Encoding = .json, packet: Encodable? = nil, setup closure: @escaping Setup = { _ in }) {
        self.init(name: name, method: method, encoding: encoding, packet: packet, setup: closure) { packet in
            do {
                return try Value(from: packet)
            } catch {
                return try Nested<Value>(from: packet).value
            }
        }
    }
}

extension SlackAction where Value == Void {
    public init(name: String, method: Method, encoding: Encoding = .json, packet: Encodable? = nil, setup closure: @escaping Setup = { _ in }) {
        self.init(name: name, method: method, encoding: encoding, packet: packet, setup: closure) { _ in () }
    }
}
