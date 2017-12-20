#if !os(Linux)
    import Foundation

    public final class PListStorage: Storage {
        // MARK: - Lifecycle
        public init() { }

        // MARK: - Public Functions
        public func get<T: LosslessStringConvertible>(key: String, from namespace: String) throws -> T {
            guard let value = dataset()[namespace]?[key] else { throw StorageError.missing(key: key) }

            guard
                let result = T(value)
                else { throw StorageError.invalid(key: key, expected: T.self, found: value) }

            return result
        }
        public func set<T: LosslessStringConvertible>(value: T, forKey key: String, in namespace: String) {
            var data = dataset()
            var items = data[namespace] ?? [:]
            items[key] = value.description
            data[namespace] = items
            saveDataset(data)
        }
        public func remove(key: String, from namespace: String) {
            var data = dataset()
            data[namespace]?.removeValue(forKey: key)
            saveDataset(data)
        }
        public func keys(in namespace: String) throws -> [String] {
            return dataset()[namespace]?.keys.values ?? []
        }

        //MARK: - Private
        private var fileName: String {
            return "\(NSHomeDirectory())/storage.plist"
        }
        private func dataset() -> [String: [String: String]] {
            guard let dict = NSDictionary(contentsOfFile: self.fileName) as? [String: [String: String]] else {
                return self.defaultDataset()
            }
            return dict
        }
        private func defaultDataset() -> [String: [String: String]] { return [:] }
        private func saveDataset(_ dataset: [String: [String: String]]) {
            (dataset as NSDictionary).write(toFile: self.fileName, atomically: true)
        }
    }
#endif
