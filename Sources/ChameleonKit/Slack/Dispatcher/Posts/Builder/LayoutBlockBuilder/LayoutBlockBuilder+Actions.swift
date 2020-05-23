public protocol ActionsContext { }
extension ModalSurface: ActionsContext { }
extension MessagesSurface: ActionsContext { }
extension HomeTabSurface: ActionsContext { }

extension LayoutBlockBuilder where Context: ActionsContext {
    public static func actions(block_id: String? = nil, elements: [BlockElementBuilder<Message.Layout.Actions>]) -> LayoutBlockBuilder {
        return .init {
            return Message.Layout.Actions(type: Message.Layout.Actions.type, elements: elements.map { $0.build() }, block_id: block_id)
        }
    }
}
