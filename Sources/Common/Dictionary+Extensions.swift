import Foundation

public extension Dictionary {
    static func +(lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        return lhs.appending(rhs)
    }

    func appending(_ other: [Key: Value]?) -> [Key: Value] {
        guard let other = other else { return self }

        var result = self
        for (key, value) in other {
            result[key] = value
        }
        return result
    }
}

public extension Dictionary {
    func map<T: Hashable, U>(_ closure: (Key, Value) throws -> (T, U)) rethrows -> [T: U] {
        return try flatMap { key, value in try closure(key, value) }
    }
    func flatMap<T: Hashable, U>(_ closure: (Key, Value) throws -> (T, U)?) rethrows -> [T: U] {
        var result: [T: U] = [:]

        for (key, value) in self {
            guard let (k, v) = try closure(key, value) else { continue }
            result[k] = v
        }

        return result
    }
}

public extension Dictionary {
    func makeString() -> String? {
        guard
            let data = try? JSONSerialization.data(withJSONObject: self, options: [])
            else { return nil }

        return String(data: data, encoding: .utf8)
    }
}
