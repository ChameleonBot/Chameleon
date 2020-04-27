extension ElementMatcher {
    public static var user: ElementMatcher {
        return .init { elements in
            guard let element = elements.first as? Message.Layout.RichText.Element.User else {
                throw Error.incorrectElement(
                    expected: Message.Layout.RichText.Element.User.self,
                    received: elements.first.map { type(of: $0) }
                )
            }
            return ([element.user_id], elements.dropFirst())
        }
    }

    public static func user(_ identifier: Identifier<User>) -> ElementMatcher {
        return .init { elements in
            guard let element = elements.first as? Message.Layout.RichText.Element.User else {
                throw Error.incorrectElement(
                    expected: Message.Layout.RichText.Element.User.self,
                    received: elements.first.map { type(of: $0) }
                )
            }

            guard element.user_id.rawValue.lowercased() == identifier.rawValue.lowercased() else {
                throw Error.matchFailed(name: "user(\(identifier.rawValue))", reason: "Found value: \(element.user_id.rawValue)")
            }

            return ([element.user_id], elements.dropFirst())
        }
    }
    public static func user(_ user: User) -> ElementMatcher {
        return self.user(user.id)
    }
}
