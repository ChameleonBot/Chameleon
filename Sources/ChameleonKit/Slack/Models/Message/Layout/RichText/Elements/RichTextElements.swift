extension Message.Layout.RichText {
    public enum Element { }
}

public protocol RichTextElement { }

extension Message.Layout.RichText.Element.Broadcast: RichTextElement { }
extension Message.Layout.RichText.Element.Channel: RichTextElement { }
extension Message.Layout.RichText.Element.Color: RichTextElement { }
//extension Message.Layout.RichText.Element.Date: RichTextElement { }
extension Message.Layout.RichText.Element.Emoji: RichTextElement { }
extension Message.Layout.RichText.Element.Link: RichTextElement { }
extension Message.Layout.RichText.Element.Team: RichTextElement { }
extension Message.Layout.RichText.Element.Text: RichTextElement { }
extension Message.Layout.RichText.Element.User: RichTextElement { }
extension Message.Layout.RichText.Element.UserGroup: RichTextElement { }

public enum RichTextElements: EquatableCodableElementSet {
    public static var decoders: [DecodingRoutine<RichTextElement>] {
        return  [
            .item(Message.Layout.RichText.Element.Broadcast.init, when: "type", equals: Message.Layout.RichText.Element.Broadcast.type),
            .item(Message.Layout.RichText.Element.Channel.init, when: "type", equals: Message.Layout.RichText.Element.Channel.type),
            .item(Message.Layout.RichText.Element.Color.init, when: "type", equals: Message.Layout.RichText.Element.Color.type),
//            .item(Message.Layout.RichText.Element.Date.init, when: "type", equals: Message.Layout.RichText.Element.Date.type),
            .item(Message.Layout.RichText.Element.Emoji.init, when: "type", equals: Message.Layout.RichText.Element.Emoji.type),
            .item(Message.Layout.RichText.Element.Link.init, when: "type", equals: Message.Layout.RichText.Element.Link.type),
            .item(Message.Layout.RichText.Element.Team.init, when: "type", equals: Message.Layout.RichText.Element.Team.type),
            .item(Message.Layout.RichText.Element.Text.init, when: "type", equals: Message.Layout.RichText.Element.Text.type),
            .item(Message.Layout.RichText.Element.User.init, when: "type", equals: Message.Layout.RichText.Element.User.type),
            .item(Message.Layout.RichText.Element.UserGroup.init, when: "type", equals: Message.Layout.RichText.Element.UserGroup.type),
            .init(decode: UnknownType.init)
        ]
    }

    public static var encoders: [EncodingRoutine<RichTextElement>] {
        return  [
            .item(Message.Layout.RichText.Element.Broadcast.self),
            .item(Message.Layout.RichText.Element.Channel.self),
            .item(Message.Layout.RichText.Element.Color.self),
//            .item(Message.Layout.RichText.Element.Date.self),
            .item(Message.Layout.RichText.Element.Emoji.self),
            .item(Message.Layout.RichText.Element.Link.self),
            .item(Message.Layout.RichText.Element.Team.self),
            .item(Message.Layout.RichText.Element.Text.self),
            .item(Message.Layout.RichText.Element.User.self),
            .item(Message.Layout.RichText.Element.UserGroup.self),
            .item(UnknownType.self)
        ]
    }

    public static func isEqual(_ lhs: RichTextElement, _ rhs: RichTextElement) -> Bool {
        switch (lhs, rhs) {
        case (let lhs as Message.Layout.RichText.Element.Broadcast, let rhs as Message.Layout.RichText.Element.Broadcast): return lhs == rhs
        case (let lhs as Message.Layout.RichText.Element.Channel, let rhs as Message.Layout.RichText.Element.Channel): return lhs == rhs
        case (let lhs as Message.Layout.RichText.Element.Color, let rhs as Message.Layout.RichText.Element.Color): return lhs == rhs
//        case (let lhs as Message.Layout.RichText.Element.Date, let rhs as Message.Layout.RichText.Element.Date): return lhs == rhs
        case (let lhs as Message.Layout.RichText.Element.Emoji, let rhs as Message.Layout.RichText.Element.Emoji): return lhs == rhs
        case (let lhs as Message.Layout.RichText.Element.Link, let rhs as Message.Layout.RichText.Element.Link): return lhs == rhs
        case (let lhs as Message.Layout.RichText.Element.Team, let rhs as Message.Layout.RichText.Element.Team): return lhs == rhs
        case (let lhs as Message.Layout.RichText.Element.Text, let rhs as Message.Layout.RichText.Element.Text): return lhs == rhs
        case (let lhs as Message.Layout.RichText.Element.User, let rhs as Message.Layout.RichText.Element.User): return lhs == rhs
        case (let lhs as Message.Layout.RichText.Element.UserGroup, let rhs as Message.Layout.RichText.Element.UserGroup): return lhs == rhs
        case (let lhs as UnknownType, let rhs as UnknownType): return lhs == rhs
        default:
            return false
        }
    }
}

