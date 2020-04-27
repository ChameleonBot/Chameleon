extension ElementMatcher {
    public static var link: ElementMatcher {
        return .init { elements in
            guard let element = elements.first as? Message.Layout.RichText.Element.Link else { return nil }
            return ([element], elements.dropFirst())
        }
    }
}
