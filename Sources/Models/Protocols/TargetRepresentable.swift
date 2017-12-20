
public enum TargetRepresentableError: Error {
    case unableToFind(value: String)
}

public protocol TargetRepresentable {
    func targetId() throws -> String
    var name: String { get }
    var targetThread_ts: String? { get }
}

extension TargetRepresentable {
    public var targetThread_ts: String? { return nil }
}

extension Channel: TargetRepresentable {
    public func targetId() throws -> String { return id }
}
extension IM: TargetRepresentable {
    public func targetId() throws -> String { return id }
    public var name: String { return "IM" }
}
extension Thread: TargetRepresentable {
    public func targetId() throws -> String {
        guard
            let value = channel?.id ?? im?.id
            else { throw TargetRepresentableError.unableToFind(value: #function) }

        return value
    }
    public var name: String { return "Thread" }
    public var targetThread_ts: String? { return thread_ts }
}
extension Group: TargetRepresentable {
    public func targetId() throws -> String { return id }
}
