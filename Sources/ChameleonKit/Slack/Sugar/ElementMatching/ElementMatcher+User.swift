extension ElementMatcher {
    public static var user: ElementMatcher {
        return .init { elements in
            guard let element = elements.first as? Message.Layout.RichText.Element.User else { return nil }
            return ([element.user_id], elements.dropFirst())
        }
    }
    public static func user(_ identifier: Identifier<User>) -> ElementMatcher {
        return .init { elements in
            guard let element = elements.first as? Message.Layout.RichText.Element.User else { return nil }
            return element.user_id.rawValue.lowercased() == identifier.rawValue.lowercased() ? ([element.user_id], elements.dropFirst()) : nil
        }
    }
    public static func user(_ user: User) -> ElementMatcher {
        return self.user(user.id)
    }
}
