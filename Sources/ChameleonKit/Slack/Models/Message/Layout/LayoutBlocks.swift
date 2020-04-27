extension Message {
    public enum Layout { }
}

public protocol LayoutBlock { }

extension Message.Layout.RichText: LayoutBlock { }
extension Message.Layout.Section: LayoutBlock { }
extension Message.Layout.Actions: LayoutBlock { }
extension Message.Layout.Context: LayoutBlock { }
extension Message.Layout.Input: LayoutBlock { }
extension Message.Layout.File: LayoutBlock { }
extension Message.Layout.Divider: LayoutBlock { }
extension Message.Layout.Image: LayoutBlock { }

public enum LayoutBlocks: EquatableCodableElementSet {
    public static var decoders: [DecodingRoutine<LayoutBlock>] {
        return [
            .item(Message.Layout.RichText.init, when: "type", equals: Message.Layout.RichText.type),
            .item(Message.Layout.Section.init, when: "type", equals: Message.Layout.Section.type),
            .item(Message.Layout.Actions.init, when: "type", equals: Message.Layout.Actions.type),
            .item(Message.Layout.Context.init, when: "type", equals: Message.Layout.Context.type),
            .item(Message.Layout.Input.init, when: "type", equals: Message.Layout.Input.type),
            .item(Message.Layout.File.init, when: "type", equals: Message.Layout.File.type),
            .item(Message.Layout.Divider.init, when: "type", equals: Message.Layout.Divider.type),
            .item(Message.Layout.Image.init, when: "type", equals: Message.Layout.Image.type),
            .init(decode: UnknownType.init)
        ]
    }

    public static var encoders: [EncodingRoutine<LayoutBlock>] {
        return [
            .item(Message.Layout.RichText.self),
            .item(Message.Layout.Section.self),
            .item(Message.Layout.Actions.self),
            .item(Message.Layout.Context.self),
            .item(Message.Layout.Input.self),
            .item(Message.Layout.File.self),
            .item(Message.Layout.Divider.self),
            .item(Message.Layout.Image.self),
            .item(UnknownType.self)
        ]
    }

    public static func isEqual(_ lhs: LayoutBlock, _ rhs: LayoutBlock) -> Bool {
        switch (lhs, rhs) {
        case (let lhs as Message.Layout.RichText, let rhs as Message.Layout.RichText): return lhs == rhs
        case (let lhs as Message.Layout.Section, let rhs as Message.Layout.Section): return lhs == rhs
        case (let lhs as Message.Layout.Actions, let rhs as Message.Layout.Actions): return lhs == rhs
        case (let lhs as Message.Layout.Context, let rhs as Message.Layout.Context): return lhs == rhs
        case (let lhs as Message.Layout.Input, let rhs as Message.Layout.Input): return lhs == rhs
        case (let lhs as Message.Layout.File, let rhs as Message.Layout.File): return lhs == rhs
        case (let lhs as Message.Layout.Divider, let rhs as Message.Layout.Divider): return lhs == rhs
        case (let lhs as Message.Layout.Image, let rhs as Message.Layout.Image): return lhs == rhs
        case (let lhs as UnknownType, let rhs as UnknownType): return lhs == rhs
        default: return false
        }
    }
}
