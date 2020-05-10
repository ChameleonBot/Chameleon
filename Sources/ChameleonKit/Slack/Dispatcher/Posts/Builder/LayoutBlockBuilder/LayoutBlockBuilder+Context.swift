public protocol ContextContext { }
extension ModalSurface: ContextContext { }
extension MessagesSurface: ContextContext { }
extension HomeTabSurface: ContextContext { }

extension LayoutBlockBuilder where Context: ContextContext {
    public static func context(block_id: String? = nil, elements: [BlockElementBuilder<Message.Layout.Context>]) -> LayoutBlockBuilder {
        return .init {
            return Message.Layout.Context(type: Message.Layout.Context.type, elements: elements.map { $0.build() }, block_id: block_id)
        }
    }
}
