
public struct Field {
    public let title: String
    public let value: String
    public let short: Bool?
}

extension Field: Common.Encodable {
    public func encode() -> [String: Any?] {
        return [
            "title": title,
            "value": value,
            "short": short,
        ]
    }
}
