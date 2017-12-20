
public struct Attachment {
    public let fallback: String?
    public let color: Color?
    public let pretext: String?

    public let author: Author?
    public let title: Title?
    public let text: String?

    public let fields: [Field]

    public let image_url: String?
    public let thumb_url: String?

    public let footer: Footer?

    public let ts: Int?
}


extension Attachment: Common.Encodable {
    public func encode() -> [String: Any?] {
        return [
            "fallback": fallback,
            "color": color?.rawValue,
            "pretext": pretext,
            "text": text,
            "fields": fields.map { $0.encode() },
            "image_url": image_url,
            "ts": ts,
            ]
            .appending(author?.encode())
            .appending(title?.encode())
            .appending(footer?.encode())
    }
}
