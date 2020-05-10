public protocol MultiSelectChannelContext { }
extension Message.Layout.Section: MultiSelectChannelContext { }
extension Message.Layout.Input: MultiSelectChannelContext { }

extension BlockElementBuilder where Context: MultiSelectChannelContext {
    public static func multiSelectChannel(action_id: String, placeholder: Text.PlainText, initial_channels: [Identifier<Channel>] = [], confirm: Confirmation? = nil, max_selected_items: Int? = nil) -> BlockElementBuilder {
        return .init {
            return MultiChannelSelect(type: MultiChannelSelect.type, placeholder: placeholder, action_id: action_id, initial_channels: initial_channels, confirm: confirm, max_selected_items: max_selected_items)
        }
    }
}
