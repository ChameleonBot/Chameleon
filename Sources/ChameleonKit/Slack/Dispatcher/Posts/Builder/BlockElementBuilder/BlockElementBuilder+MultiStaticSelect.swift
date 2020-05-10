public protocol MultiSelectStaticContext { }
extension Message.Layout.Section: MultiSelectStaticContext { }
extension Message.Layout.Input: MultiSelectStaticContext { }

extension BlockElementBuilder where Context: MultiSelectStaticContext {
    public static func multiSelect(action_id: String, placeholder: Text.PlainText, options: [Option] = [], initial_options: [Option] = [], confirm: Confirmation? = nil, max_selected_items: Int? = nil) -> BlockElementBuilder {
        return .init {
            let initial_options = initial_options.filter(options.contains)
            return MultiStaticSelect(type: MultiStaticSelect.type, placeholder: placeholder, action_id: action_id, options: options, initial_options: initial_options, confirm: confirm, max_selected_items: max_selected_items)
        }
    }
}
