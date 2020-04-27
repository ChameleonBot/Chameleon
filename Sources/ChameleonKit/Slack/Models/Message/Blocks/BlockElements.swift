public protocol BlockElement { }

extension Button: BlockElement { }
extension CheckboxGroup: BlockElement { }
extension DatePicker: BlockElement { }
extension Image: BlockElement { }
extension MultiChannelSelect: BlockElement { }
extension MultiConversationSelect: BlockElement { }
extension MultiExternalSelect: BlockElement { }
extension MultiStaticSelect: BlockElement { }
extension MultiUserSelect: BlockElement { }
extension Overflow: BlockElement { }
extension RadioGroup: BlockElement { }
extension SelectChannel: BlockElement { }
extension SelectConversation: BlockElement { }
extension SelectExternal: BlockElement { }
extension SelectStatic: BlockElement { }
extension SelectUser: BlockElement { }
extension TextInput: BlockElement { }

public enum BlockElements: EquatableCodableElementSet {
    public static var decoders: [DecodingRoutine<BlockElement>] {
        return [
            .item(Button.init, when: "type", equals: Button.type),
            .item(CheckboxGroup.init, when: "type", equals: CheckboxGroup.type),
            .item(DatePicker.init, when: "type", equals: DatePicker.type),
            .item(Image.init, when: "type", equals: Image.type),
            .item(MultiChannelSelect.init, when: "type", equals: MultiChannelSelect.type),
            .item(MultiConversationSelect.init, when: "type", equals: MultiConversationSelect.type),
            .item(MultiExternalSelect.init, when: "type", equals: MultiExternalSelect.type),
            .item(MultiStaticSelect.init, when: "type", equals: MultiStaticSelect.type),
            .item(MultiUserSelect.init, when: "type", equals: MultiUserSelect.type),
            .item(Overflow.init, when: "type", equals: Overflow.type),
            .item(RadioGroup.init, when: "type", equals: RadioGroup.type),
            .item(SelectChannel.init, when: "type", equals: SelectChannel.type),
            .item(SelectConversation.init, when: "type", equals: SelectConversation.type),
            .item(SelectExternal.init, when: "type", equals: SelectExternal.type),
            .item(SelectStatic.init, when: "type", equals: SelectStatic.type),
            .item(SelectUser.init, when: "type", equals: SelectUser.type),
            .item(TextInput.init, when: "type", equals: TextInput.type),
            .init(decode: UnknownType.init)
        ]
    }

    public static var encoders: [EncodingRoutine<BlockElement>] {
        return [
            .item(Button.self),
            .item(CheckboxGroup.self),
            .item(DatePicker.self),
            .item(Image.self),
            .item(MultiChannelSelect.self),
            .item(MultiConversationSelect.self),
            .item(MultiExternalSelect.self),
            .item(MultiStaticSelect.self),
            .item(MultiUserSelect.self),
            .item(Overflow.self),
            .item(RadioGroup.self),
            .item(SelectChannel.self),
            .item(SelectConversation.self),
            .item(SelectExternal.self),
            .item(SelectStatic.self),
            .item(SelectUser.self),
            .item(TextInput.self),
            .item(UnknownType.self)
        ]
    }

    public static func isEqual(_ lhs: BlockElement, _ rhs: BlockElement) -> Bool {
        switch (lhs, rhs) {
        case (let lhs as Button, let rhs as Button): return lhs == rhs
        case (let lhs as CheckboxGroup, let rhs as CheckboxGroup): return lhs == rhs
        case (let lhs as DatePicker, let rhs as DatePicker): return lhs == rhs
        case (let lhs as Image, let rhs as Image): return lhs == rhs
        case (let lhs as MultiChannelSelect, let rhs as MultiChannelSelect): return lhs == rhs
        case (let lhs as MultiConversationSelect, let rhs as MultiConversationSelect): return lhs == rhs
        case (let lhs as MultiExternalSelect, let rhs as MultiExternalSelect): return lhs == rhs
        case (let lhs as MultiStaticSelect, let rhs as MultiStaticSelect): return lhs == rhs
        case (let lhs as MultiUserSelect, let rhs as MultiUserSelect): return lhs == rhs
        case (let lhs as Overflow, let rhs as Overflow): return lhs == rhs
        case (let lhs as RadioGroup, let rhs as RadioGroup): return lhs == rhs
        case (let lhs as SelectChannel, let rhs as SelectChannel): return lhs == rhs
        case (let lhs as SelectConversation, let rhs as SelectConversation): return lhs == rhs
        case (let lhs as SelectExternal, let rhs as SelectExternal): return lhs == rhs
        case (let lhs as SelectStatic, let rhs as SelectStatic): return lhs == rhs
        case (let lhs as SelectUser, let rhs as SelectUser): return lhs == rhs
        case (let lhs as TextInput, let rhs as TextInput): return lhs == rhs
        case (let lhs as UnknownType, let rhs as UnknownType): return lhs == rhs
        default: return false
        }
    }
}
