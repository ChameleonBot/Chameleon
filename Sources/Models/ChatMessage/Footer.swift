
public struct Footer {
    public let footer: String
    public let icon: String?
}

extension Footer: Common.Encodable {
    public func encode() -> [String: Any?] {
        return [
            "footer": footer,
            "footer_icon": icon,
        ]
    }
}
