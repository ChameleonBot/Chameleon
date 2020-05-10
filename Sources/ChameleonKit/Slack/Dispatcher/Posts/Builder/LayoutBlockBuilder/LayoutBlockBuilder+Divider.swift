public protocol DividerContext { }
extension ModalSurface: DividerContext { }
extension MessagesSurface: DividerContext { }
extension HomeTabSurface: DividerContext { }

extension LayoutBlockBuilder where Context: DividerContext {
    public static func divider(block_id: String? = nil) -> LayoutBlockBuilder {
        return .init {
            return Message.Layout.Divider(type: Message.Layout.Divider.type, block_id: block_id)
        }
    }
}
