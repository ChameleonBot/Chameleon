public protocol SelectChannelContext { }
extension Message.Layout.Section: SelectChannelContext { }
extension Message.Layout.Actions: SelectChannelContext { }
extension Message.Layout.Input: SelectChannelContext { }

extension BlockElementBuilder where Context: SelectChannelContext {
    public static func selectChannell(action_id: String, placeholder: Text.PlainText, initial_channel: Identifier<Channel>? = nil, confirm: Confirmation? = nil, response_url_enabled: Bool? = nil) -> BlockElementBuilder {
        return .init {
            return SelectChannel(type: SelectChannel.type, placeholder: placeholder, action_id: action_id, initial_channel: initial_channel, confirm: confirm, response_url_enabled: response_url_enabled)
        }
    }
}
