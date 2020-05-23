extension ElementMatcher {
    public static var link: ElementMatcher {
        return .init { elements in
            guard let element = elements.first as? Message.Layout.RichText.Element.Link else {
                throw Error.incorrectElement(
                    expected: Message.Layout.RichText.Element.Link.self,
                    received: elements.first.map { type(of: $0) }
                )
            }
            return ([element], elements.dropFirst())
        }
    }
}
