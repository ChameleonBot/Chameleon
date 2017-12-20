
open class Decoder {
    // MARK: - Public Properties
    public let data: KeyPathAccessible

    // MARK: - Lifecycle
    public init(data: KeyPathAccessible) {
        self.data = data
    }

    // MARK: - Public
    public func value<T>(of type: T.Type = T.self, at keyPath: [KeyPathComponent]) throws -> T {
        guard let last = keyPath.last else { throw KeyPathError.invalid(key: keyPath) }

        do {
            return try keyPath
                .dropLast()
                .reduce(data) { try $0.path(at: $1) }
                .value(at: last)

        } catch let error as KeyPathError {
            switch error {
            case .invalid:
                throw KeyPathError.invalid(key: keyPath)
            case .missing:
                throw KeyPathError.missing(key: keyPath)
            case .mismatch(_, let expected, let got):
                throw KeyPathError.mismatch(key: keyPath, expected: expected, found: got)
            }

        } catch let error {
            throw error
        }
    }
}
