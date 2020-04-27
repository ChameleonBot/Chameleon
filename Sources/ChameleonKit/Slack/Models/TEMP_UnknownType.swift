import Foundation

public struct UnknownType: Codable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case type
    }

    let type: String

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)

        print("")
        print("!!! UnknownType:", self.type)
        guard let json = decoder.userInfo[.json] as? String else { print(""); return }
        print("!!! - Packet:\n\(json)")
        print("")
    }
}

extension CodingUserInfoKey {
    public static var json: CodingUserInfoKey { return CodingUserInfoKey(rawValue: #function)! }
}

extension JSONDecoder {
    func debug(_ json: [String: Any]) throws -> JSONDecoder {
        let pretty = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        userInfo[.json] = String(data: pretty, encoding: .utf8) ?? "no data"
        return self
    }
}
extension UnknownType: LayoutBlock { }
extension UnknownType: RichTextContainer { }
extension UnknownType: RichTextElement { }
extension UnknownType: BlockElement { }
