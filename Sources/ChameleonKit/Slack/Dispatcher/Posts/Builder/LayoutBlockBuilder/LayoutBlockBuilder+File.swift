public protocol FileContext { }
extension MessagesSurface: FileContext { }

extension LayoutBlockBuilder where Context: FileContext {
    public static func file(block_id: String? = nil, external_id: String, source: Message.Layout.File.Source) -> LayoutBlockBuilder {
        return .init {
            return Message.Layout.File(type: Message.Layout.File.type, external_id: external_id, source: source, block_id: block_id)
        }
    }
}
