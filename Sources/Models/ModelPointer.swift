
public struct ModelPointer<Model: IDRepresentable>: IDRepresentable {
    public let id: String

    public init(id: String) {
        self.id = id
    }
}

extension ModelPointer: Common.Decodable {
    public init(decoder: Common.Decoder) throws {
        self = try decode {
            return ModelPointer(id: try decoder.value(at: ["id"]))
        }
    }
}

public protocol ModelPointerType {
    associatedtype ModelType: IDRepresentable

    var id: String { get }
}

extension ModelPointer: ModelPointerType {
    public typealias ModelType = Model
}

extension ModelPointer: LosslessStringConvertible {
    public init?(_ description: String) {
        self.init(id: description)
    }
    public var description: String {
        return id
    }
}

extension ModelPointer: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
    public static func ==(lhs: ModelPointer<Model>, rhs: ModelPointer<Model>) -> Bool {
        return lhs.id == rhs.id
    }
}
