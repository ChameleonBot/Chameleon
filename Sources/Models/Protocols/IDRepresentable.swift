
public protocol IDRepresentable {
    var id: String { get }
}

extension BotUser: IDRepresentable { }
extension Team: IDRepresentable { }
extension User: IDRepresentable { }
extension Channel: IDRepresentable { }
extension IM: IDRepresentable { }
extension Group: IDRepresentable { }
