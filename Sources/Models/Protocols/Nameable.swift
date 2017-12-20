
public protocol Nameable {
    var name: String { get }
}

extension BotUser: Nameable { }
extension Team: Nameable { }
extension User: Nameable {
    public var name: String {
        return display_name
    }
}
extension Channel: Nameable { }
extension IM: Nameable { }
extension Group: Nameable { }
