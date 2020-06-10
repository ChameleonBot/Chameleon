extension Message {
    public func mentions() -> [Identifier<User>] {
        return richText()
            .compactMap { $0 as? Layout.RichText.Element.User }
            .map { $0.user_id }
    }

    public func links() -> [Layout.RichText.Element.Link] {
        return richText().compactMap { $0 as? Layout.RichText.Element.Link }
    }

    public func channels() -> [Identifier<Channel>] {
        return richText()
            .compactMap { $0 as? Layout.RichText.Element.Channel }
            .map { $0.channel_id }
    }

    public var isUnfurl: Bool {
        guard subtype == .message_changed, let previous = previous else { return false }
        guard previous.text == text else { return false }
        guard previous.attachments.isEmpty, attachments.contains(where: { $0.original_url != nil }) else { return false }

        return true
    }
}
