
public struct Author {
    public let name: String
    public let link: String?
    public let icon: String?
}

extension Author: Common.Encodable {
    public func encode() -> [String: Any?] {
        return [
            "author_name": name,
            "author_link": link,
            "author_icon": icon,
        ]
    }
}
