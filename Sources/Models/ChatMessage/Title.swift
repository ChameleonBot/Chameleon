
public struct Title {
    public let title: String
    public let link: String?
}

extension Title: Common.Encodable {
    public func encode() -> [String: Any?] {
        return [
            "title": title,
            "title_link": link,
        ]
    }
}
