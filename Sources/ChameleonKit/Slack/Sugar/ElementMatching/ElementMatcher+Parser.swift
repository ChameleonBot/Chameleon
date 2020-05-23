extension ElementMatcher {
    public init<T>(_ parser: Parser<T>) {
        self.init { elements in
            guard let element = elements.first as? Message.Layout.RichText.Element.Text else {
                throw Error.incorrectElement(
                    expected: Message.Layout.RichText.Element.Text.self,
                    received: elements.first.map { type(of: $0) }
                )
            }

            do {
                let match = try parser.parse(element.text[...])
                return ([match.value], elements.dropFirst())

            } catch ParserError.matchFailed(let name, let reason) {
                throw Error.matchFailed(name: name, reason: reason)
            }
        }
    }
}
