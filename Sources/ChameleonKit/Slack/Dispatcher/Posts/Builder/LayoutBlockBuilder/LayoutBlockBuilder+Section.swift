public protocol SectionContext { }
extension ModalSurface: SectionContext { }
extension MessagesSurface: SectionContext { }
extension HomeTabSurface: SectionContext { }

extension LayoutBlockBuilder where Context: SectionContext {
    public static func section(block_id: String? = nil, text: Text, fields: [Text] = [], accessory: BlockElementBuilder<Message.Layout.Section>? = nil) -> LayoutBlockBuilder {
        return .init {
            return Message.Layout.Section(
                type: Message.Layout.Section.type,
                text: text,
                block_id: block_id,
                fields: fields.isEmpty ? nil : fields,
                accessory: accessory?.build()
            )
        }
    }
}
