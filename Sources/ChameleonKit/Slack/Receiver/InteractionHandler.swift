import Foundation

public class InteractionHandler {
    // MARK: - Private Properties
    private let verificationToken: String
    private var registeredActions: [String: () throws -> Void] = [:]

    // MARK: - Public Properties
    public var onError: (Error) -> Void = { _ in fatalError("Error handler not attached") }

    // MARK: - Lifecycle
    public init(verificationToken: String) {
        self.verificationToken = verificationToken
    }
    
    // MARK: - Public Functions
    public func registerAction(id: String, closure: @escaping () throws -> Void) {
        registeredActions[id] = closure
    }
    public func handle(data: Data) {
        do {
            let jsonPacket = try JSONSerialization.jsonObject(with: data, options: [])

            guard let json = jsonPacket as? [String: Any] else { throw SlackPacketError.invalidPacket(jsonPacket) }
            guard let token = json["token"] as? String else { throw SlackPacketError.noToken(json) }
            guard token == verificationToken else { throw SlackPacketError.invalidToken(json) }

            do {
                let interaction = try Interaction(from: json)
                for action in interaction.actions {
                    if let closure = registeredActions[action.action_id] {
                        try closure()

                    } else {
                        throw UnregisteredActionError(action_id: action.action_id)
                    }
                }

            } catch let error {
                throw InteractionError(interaction: json, error: error)
            }

        } catch let error {
            onError(error)
        }
    }
}
