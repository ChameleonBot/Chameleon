import ChameleonKit
import Foundation
import class Foundation.Bundle

public struct FixtureSource<Context, T> {
    public let data: () throws -> Data

    public init(data: @escaping () throws -> Data) {
        self.data = data
    }
}

extension Decodable {
    public init<C>(from source: FixtureSource<C, Self>) throws {
        let data = try source.data()
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}

extension FixtureSource {
    public init(raw: String) {
        self.init(data: { Data(raw.utf8) })
    }
    public init(jsonFile fileName: String, map: [FixtureKey: LosslessStringConvertible] = [:], source: String = #file) throws {
        let file = URL(fileURLWithPath: source)
        let directory = file.deletingLastPathComponent()
        let url = directory.appendingPathComponent("\(fileName).json")

        self.data = {
            guard !map.isEmpty else { return try Data(contentsOf: url) }

            let string = try String(contentsOf: url)
            let mapped = map.reduce(string) { $0.replacingOccurrences(of: "%\($1.key.rawValue)%", with: $1.value.description) }
            return Data(mapped.utf8)
        }
    }
}

public struct EncodeMany<Set: CodableElementSet>: Encodable {
    @ManyOf<Set> public var values: [Set.Element]

    public func encode(to encoder: Encoder) throws {
        try _values.encode(to: encoder)
    }
}
