import Foundation

public protocol ButtonContext { }
extension Message.Layout.Section: ButtonContext { }
extension Message.Layout.Actions: ButtonContext { }

extension BlockElementBuilder where Context: ButtonContext {
    public static func button(action_id: String, value: String? = nil, text: Text.PlainText, url: URL? = nil, style: Style? = nil, confirm: Confirmation?) -> BlockElementBuilder {
        return .init { return Button(type: Button.type, text: text, action_id: action_id, url: url, value: value, style: style, confirm: confirm) }
    }
}
