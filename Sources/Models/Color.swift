
public enum Color: RawRepresentable {
    case good
    case warning
    case danger
    case hex(value: String)

    public init?(rawValue: String) {
        let basicRawValues = [Color.good, Color.warning, Color.danger]

        if let index = basicRawValues.index(where: { $0.rawValue == rawValue }) {
            self = basicRawValues[index]
        } else {
            self = .hex(value: rawValue)
        }
    }
    public var rawValue: String {
        switch self {
        case .danger: return "danger"
        case .good: return "good"
        case .warning: return "warning"
        case .hex(let value): return value
        }
    }
}

extension Color {
    public static var black: Color { return .hex(value: "#000000") }
    public static var darkGray: Color { return .hex(value: "#555555") }
    public static var lightGray: Color { return .hex(value: "#aaaaaa") }
    public static var white: Color { return .hex(value: "#ffffff") }
    public static var gray: Color { return .hex(value: "#808080") }
    public static var red: Color { return .hex(value: "#ff00000") }
    public static var blue: Color { return .hex(value: "#0000ff") }
    public static var cyan: Color { return .hex(value: "#00ffff") }
    public static var yellow: Color { return .hex(value: "#ffff00") }
    public static var magenta: Color { return .hex(value: "#ff00ff") }
    public static var orange: Color { return .hex(value: "#ff8000") }
    public static var purple: Color { return .hex(value: "#800080") }
    public static var brown: Color { return .hex(value: "#996633") }
}
