public protocol PlainTextInputContext { }
extension Message.Layout.Section: PlainTextInputContext { }
extension Message.Layout.Actions: PlainTextInputContext { }
extension Message.Layout.Input: PlainTextInputContext { }

extension BlockElementBuilder where Context: PlainTextInputContext {
    public static func textInput(action_id: String, placeholder: Text.PlainText? = nil, initial_value: String? = nil, multiline: Bool = false, min_length: Int? = nil, max_length: Int? = nil) -> BlockElementBuilder {
        return .init {
            return TextInput(type: TextInput.type, action_id: action_id, placeholder: placeholder, initial_value: initial_value, multiline: multiline, min_length: min_length, max_length: max_length)
        }
    }
}
