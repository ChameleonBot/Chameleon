import ChameleonKit
import Foundation
import class Foundation.Bundle

struct FixtureSource<T> {
    let data: () throws -> Data
}

extension Decodable {
    init(from source: FixtureSource<Self>) throws {
        let data = try source.data()
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}

extension FixtureSource {
    init(json fileName: String, map: [FixtureKey: LosslessStringConvertible] = [:], source: String = #file) throws {
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

struct EncodeMany<Set: CodableElementSet>: Encodable {
    @ManyOf<Set> var values: [Set.Element]

    func encode(to encoder: Encoder) throws {
        try _values.encode(to: encoder)
    }
}