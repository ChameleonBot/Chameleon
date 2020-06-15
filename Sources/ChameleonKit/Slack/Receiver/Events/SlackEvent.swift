import Foundation

public struct SlackEvent<Result> {
    public typealias CanHandle = (_ type: String, _ json: [String: Any]) -> Bool
    public typealias Handler = (_ json: [String: Any]) throws -> Result

    public let identifier: String
    public let canHandle: CanHandle
    public let handle: Handler

    public init(identifier: String, canHandle: @escaping CanHandle, handler: @escaping Handler) {
        self.identifier = identifier
        self.canHandle = canHandle
        self.handle = handler
    }

    public init(identifier: String, type: String, handler: @escaping Handler) {
        self.init(identifier: identifier, canHandle: { t, _ in t == type }, handler: handler)
    }
}

extension SlackEvent where Result: Decodable {
    public init(identifier: String, canHandle: @escaping CanHandle) {
        self.init(
            identifier: identifier,
            canHandle: canHandle,
            handler: { json in
                do {
                    return try Result(from: json, decoder: JSONDecoder().debug(json))
                } catch {
                    return try Nested<Result>(from: json, decoder: JSONDecoder().debug(json)).value
                }
            }
        )
    }

    public init(identifier: String, type: String) {
        self.init(identifier: identifier, canHandle: { t, _ in t == type })
    }
}
