import Foundation

public protocol LosslessStringCodable: Codable, LosslessStringConvertible {
    //
}

extension LosslessStringCodable {
    public init?(_ description: String) {
        guard
            let data = description.data(using: .utf8),
            let value = try? JSONDecoder().decode(Self.self, from: data)
            else { return nil }

        self = value
    }

    public var description: String {
        let encoded = (try? JSONEncoder().encode(self)).flatMap { String(data: $0, encoding: .utf8) }
        return encoded ?? "\(Self.self)"
    }
}
