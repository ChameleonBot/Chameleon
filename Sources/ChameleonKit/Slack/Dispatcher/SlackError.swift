import Foundation

public struct SlackError: Error, Equatable, Decodable {
    public var ok: Bool
    public var error: String
    public var packet: [String: String]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        self.ok = try container.decode(Bool.self, forKey: "ok")
        self.error = try container.decode(String.self, forKey: "error")

        var packet: [String: String] = [:]
        for key in container.allKeys {
            if let value = try? container.decode(String.self, forKey: key) {
                packet[key.stringValue] = value
            } else if let value = try? container.decode(Int.self, forKey: key) {
                packet[key.stringValue] = "\(value)"
            } else if let value = try? container.decode(Bool.self, forKey: key) {
                packet[key.stringValue] = "\(value)"
            } else {
                print("Ignoring key '\(key.stringValue)' with unsupported type")
            }
        }
        self.packet = packet
    }
}
