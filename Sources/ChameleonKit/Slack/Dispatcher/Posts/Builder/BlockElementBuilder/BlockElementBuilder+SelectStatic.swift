public protocol SelectStaticContext { }
extension Message.Layout.Section: SelectStaticContext { }
extension Message.Layout.Actions: SelectStaticContext { }
extension Message.Layout.Input: SelectStaticContext { }

extension BlockElementBuilder where Context: SelectStaticContext {
    public static func select(action_id: String, placeholder: Text.PlainText, options: [Option], initial_options: [Option] = [], confirm: Confirmation? = nil) -> BlockElementBuilder {
        return .init {
            let initial_options = initial_options.filter(options.contains)
            return SelectStatic(type: SelectStatic.type, placeholder: placeholder, action_id: action_id, options: options, initial_options: initial_options, confirm: confirm)
        }
    }
}
