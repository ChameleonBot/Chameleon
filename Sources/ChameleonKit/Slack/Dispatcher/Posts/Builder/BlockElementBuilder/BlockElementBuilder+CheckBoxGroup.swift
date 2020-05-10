public protocol CheckBoxGroupContext { }
extension Message.Layout.Section: CheckBoxGroupContext { }
extension Message.Layout.Actions: CheckBoxGroupContext { }
extension Message.Layout.Input: CheckBoxGroupContext { }

extension BlockElementBuilder where Context: CheckBoxGroupContext {
    public static func checkboxGroup(action_id: String, options: [Option], initial_options: [Option] = [], confirm: Confirmation? = nil) -> BlockElementBuilder {
        return .init {
            let initial_options = initial_options.filter(options.contains)
            return CheckboxGroup(type: CheckboxGroup.type, action_id: action_id, options: options, initial_options: initial_options, confirm: confirm)
        }
    }
}
