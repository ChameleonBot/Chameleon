public protocol RichTextContainer { }

extension Message.Layout.RichText.Section: RichTextContainer { }
extension Message.Layout.RichText.Preformatted: RichTextContainer { }
extension Message.Layout.RichText.Quote: RichTextContainer { }
extension Message.Layout.RichText.List: RichTextContainer { }

public enum RichTextContainers: EquatableCodableElementSet {
    public static var decoders: [DecodingRoutine<RichTextContainer>] {
        return [
            .item(Message.Layout.RichText.Section.init, when: "type", equals: Message.Layout.RichText.Section.type),
            .item(Message.Layout.RichText.Preformatted.init, when: "type", equals: Message.Layout.RichText.Preformatted.type),
            .item(Message.Layout.RichText.Quote.init, when: "type", equals: Message.Layout.RichText.Quote.type),
            .item(Message.Layout.RichText.List.init, when: "type", equals: Message.Layout.RichText.List.type),
            .init(decode: UnknownType.init)
        ]
    }
    
    public static var encoders: [EncodingRoutine<RichTextContainer>] {
        return [
            .item(Message.Layout.RichText.Section.self),
            .item(Message.Layout.RichText.Preformatted.self),
            .item(Message.Layout.RichText.Quote.self),
            .item(Message.Layout.RichText.List.self),
            .item(UnknownType.self)
        ]
    }

    public static func isEqual(_ lhs: RichTextContainer, _ rhs: RichTextContainer) -> Bool {
        switch (lhs, rhs) {
        case (let lhs as Message.Layout.RichText.Section, let rhs as Message.Layout.RichText.Section): return lhs == rhs
        case (let lhs as Message.Layout.RichText.Preformatted, let rhs as Message.Layout.RichText.Preformatted): return lhs == rhs
        case (let lhs as Message.Layout.RichText.Quote, let rhs as Message.Layout.RichText.Quote): return lhs == rhs
        case (let lhs as Message.Layout.RichText.List, let rhs as Message.Layout.RichText.List): return lhs == rhs
        case (let lhs as UnknownType, let rhs as UnknownType): return lhs == rhs
        default: return false
        }
    }
}
