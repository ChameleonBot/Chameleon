public protocol InputContext { }
extension ModalSurface: InputContext { }

extension LayoutBlockBuilder where Context: InputContext {
    public static func input(block_id: String? = nil, label: Text.PlainText, element: BlockElementBuilder<Message.Layout.Input>, hint: Text.PlainText? = nil, optional: Bool = false) -> LayoutBlockBuilder {
        return .init {
            return Message.Layout.Input(type: Message.Layout.Input.type, label: label, element: element.build(), block_id: block_id, hint: hint, optional: optional)
        }
    }
}
