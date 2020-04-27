extension Message {
    public func mentions() -> [Identifier<User>] {
        return richText()
            .compactMap { $0 as? Layout.RichText.Element.User }
            .map { $0.user_id }
    }

    public func links() -> [Layout.RichText.Element.Link] {
        return richText().compactMap { $0 as? Layout.RichText.Element.Link }
    }
}
