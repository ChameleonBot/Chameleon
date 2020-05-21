import Foundation

public struct Directory {
    let path: () -> String

    public init(path: @escaping () -> String) {
        self.path = path
    }
}

extension Directory {
    public static var home: Directory { .init { NSHomeDirectory() } }
    public static var temp: Directory { .init { NSTemporaryDirectory() } }
}

public class PListKeyValueStorage: KeyValueStorage {
    private let filename: String
    private let data: NSMutableDictionary

    public init(directory: Directory = .home, name: String) {
        let filename = "\(directory.path())/\(name).plist"

        self.filename = filename
        self.data = NSMutableDictionary(contentsOfFile: filename) ?? .init()
    }
    public func get<T: LosslessStringConvertible>(forKey key: String) throws -> T {
        guard let string = data[key] as? String else { throw KeyValueStorageError.missing(key: key) }
        guard let value = T(string) else { throw KeyValueStorageError.invalid(key: key, expected: T.self, found: string) }
        return value
    }
    public func set<T: LosslessStringConvertible>(value: T, forKey key: String) throws {
        data[key] = value.description
        save()
    }
    public func remove(forKey key: String) throws {
        data[key] = nil
        save()
    }

    private func save() {
        data.write(toFile: filename, atomically: true)
    }
}
