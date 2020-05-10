public protocol DatePickerContext { }
extension Message.Layout.Section: DatePickerContext { }
extension Message.Layout.Actions: DatePickerContext { }
extension Message.Layout.Input: DatePickerContext { }

extension BlockElementBuilder where Context: DatePickerContext {
    public static func datePicker(action_id: String, placeholder: Text.PlainText? = nil, initial_date: CalendarDate? = nil, confirm: Confirmation? = nil) -> BlockElementBuilder {
        return .init {
            return DatePicker(type: DatePicker.type, action_id: action_id, placeholder: placeholder, initial_date: initial_date, confirm: confirm)
        }
    }
}
