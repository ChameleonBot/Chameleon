public protocol OverflowContext { }
extension Message.Layout.Section: OverflowContext { }
extension Message.Layout.Actions: OverflowContext { }

extension BlockElementBuilder where Context: OverflowContext {
    public static func overflow(action_id: String, options: [Option], confirm: Confirmation? = nil) -> BlockElementBuilder {
        return .init {
            return Overflow(type: Overflow.type, action_id: action_id, options: options, confirm: confirm)
        }
    }
}
