import Foundation

public protocol DataRepresentable {
    func makeData() -> Data?
}

public extension DataRepresentable {
    var string: String {
        guard let data = self.makeData() else { return "" }
        return String(data: data, encoding: .utf8) ?? ""
    }
}

extension Data: DataRepresentable {
    public func makeData() -> Data? {
        return self
    }
}

extension Dictionary: DataRepresentable {
    public func makeData() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [])
    }
}
