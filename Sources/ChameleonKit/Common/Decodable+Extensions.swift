import Foundation

extension Decodable {
    public init(from json: [String: Any], decoder: JSONDecoder = .init()) throws {
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        self = try decoder.decode(Self.self, from: data)
    }
}
