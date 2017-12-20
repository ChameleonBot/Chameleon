
enum SlackModelTypeVendorError: Error {
    case noStorageConfigured
}

/// Represents an object capable of turning object ids into complete object models
public protocol SlackModelTypeVendor {
    /// Attempts to convert the provided object id into a complete object model
    func model<T: ModelWebAPIRequestRepresentable>(id: String) throws -> T
}

/// Provides the default model vending behaviour
/// Models retrieved from the web api are cached so subsequent requests for complete models
/// don't require additional web api requests
public final class DefaultSlackModelTypeVendor: SlackModelTypeVendor {

    // TODO: Add the ability to 'expire' stored objects

    // MARK: - Private Properties
    private let webApi: WebAPI
    private var stored: [String: Any] = [:]

    // MARK: - Lifecycle
    /// Create a new instance
    ///
    /// - Parameter webApi: The `WebAPI` that will be used to retrieve full models from provided ids
    public init(webApi: WebAPI) {
        self.webApi = webApi
    }

    // MARK: - Public Functions
    public func model<T: ModelWebAPIRequestRepresentable>(id: String) throws -> T {
        if let object = stored[id] as? T {
            return object
        }

        let request = T.request(id: id)

        do {
            let result = try webApi.perform(request: request)
            stored[id] = result
            return result

        } catch let error {
            throw error
        }
    }
}
