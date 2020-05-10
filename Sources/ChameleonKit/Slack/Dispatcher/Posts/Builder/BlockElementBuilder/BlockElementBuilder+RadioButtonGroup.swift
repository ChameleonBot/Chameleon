public protocol RadioButtonGroupContext { }
extension Message.Layout.Section: RadioButtonGroupContext { }
extension Message.Layout.Actions: RadioButtonGroupContext { }
extension Message.Layout.Input: RadioButtonGroupContext { }

extension BlockElementBuilder where Context: RadioButtonGroupContext {
    public static func radioButtonGroup(action_id: String, options: [Option], initial_option: Option? = nil, confirm: Confirmation? = nil) -> BlockElementBuilder {
        return .init {
            let initial_option = initial_option.flatMap { options.contains($0) ? $0 : nil }
            return RadioGroup(type: RadioGroup.type, action_id: action_id, options: options, initial_option: initial_option, confirm: confirm)
        }
    }
}
