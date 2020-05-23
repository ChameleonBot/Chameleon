/*
public enum BlockElement: Codable, Equatable {
    case button(Button)
    case checkboxGroup(CheckboxGroup)
    case datePicker(DatePicker)
    case image(Image)
    case multiChannelSelect(MultiChannelSelect)
    case multiConversationSelect(MultiConversationSelect)
    case multiExternalSelect(MultiExternalSelect)
    case multiStaticSelect(MultiStaticSelect)
    case multiUserSelect(MultiUserSelect)
    case overflow(Overflow)
    case radioGroup(RadioGroup)
    case selectChannel(SelectChannel)
    case selectConversation(SelectConversation)
    case selectExternal(SelectExternal)
    case selectStatic(SelectStatic)
    case selectUser(SelectUser)
    case textInput(TextInput)

    public init(from decoder: Decoder) throws {
        self = try decoder.decodeFirst(from: [
            .case(BlockElement.button, when: "type", equals: Button.type),
            .case(BlockElement.checkboxGroup, when: "type", equals: CheckboxGroup.type),
            .case(BlockElement.datePicker, when: "type", equals: DatePicker.type),
            .case(BlockElement.image, when: "type", equals: Image.type),

            .case(BlockElement.multiChannelSelect, when: "type", equals: MultiChannelSelect.type),
            .case(BlockElement.multiConversationSelect, when: "type", equals: MultiConversationSelect.type),
            .case(BlockElement.multiExternalSelect, when: "type", equals: MultiExternalSelect.type),
            .case(BlockElement.multiStaticSelect, when: "type", equals: MultiStaticSelect.type),
            .case(BlockElement.multiUserSelect, when: "type", equals: MultiUserSelect.type),

            .case(BlockElement.overflow, when: "type", equals: Overflow.type),
            .case(BlockElement.radioGroup, when: "type", equals: RadioGroup.type),

            .case(BlockElement.selectChannel, when: "type", equals: SelectChannel.type),
            .case(BlockElement.selectConversation, when: "type", equals: SelectConversation.type),
            .case(BlockElement.selectExternal, when: "type", equals: SelectExternal.type),
            .case(BlockElement.selectStatic, when: "type", equals: SelectStatic.type),
            .case(BlockElement.selectUser, when: "type", equals: SelectUser.type),

            .case(BlockElement.textInput, when: "type", equals: TextInput.type),
        ])
    }
    public func encode(to encoder: Encoder) throws {
        //
    }
}
*/
