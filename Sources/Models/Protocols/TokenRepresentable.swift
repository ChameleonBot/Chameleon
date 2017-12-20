
public protocol TokenRepresentable {
    static var token: String { get }
}

extension User: TokenRepresentable {
    public static var token: String { return "@" }
}

extension BotUser: TokenRepresentable {
    public static var token: String { return "@" }
}

extension Channel: TokenRepresentable {
    public static var token: String { return "#" }
}

extension Group: TokenRepresentable {
    public static var token: String { return "" } // groups don't have tokens :\
}
