import Foundation

// MARK: - NetworkResponse
public struct NetworkResponse {
    public let response: HTTPURLResponse
    public let data: Data?

    public init(response: HTTPURLResponse, data: Data?) {
        self.response = response
        self.data = data
    }
}

// MARK: - Conversions
public extension NetworkResponse {
    var jsonDictionary: [String: Any]? {
        guard let data = self.data else { return nil }

        do { return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] }
        catch { return nil }
    }
    var jsonArray: [Any]? {
        guard let data = self.data else { return nil }

        do { return try JSONSerialization.jsonObject(with: data, options: []) as? [Any] }
        catch { return nil }
    }
    var string: String? {
        guard
            let data = self.data,
            let value = String(data: data, encoding: .utf8),
            !value.isEmpty
            else { return nil }

        return value
    }
}

// MARK: - CustomStringConvertible
extension NetworkResponse: CustomStringConvertible {
    public var description: String {
        return "\(self.response)\nDATA:\n\(self.string ?? "<empty>")"
    }
}
