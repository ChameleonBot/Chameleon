
var sharedModelVendor: SlackModelTypeVendor?

public extension ModelPointer where Model: ModelWebAPIRequestRepresentable {
    /// Attempts to return the complete model object for this pointer
    func value() throws -> Model {
        guard let shared = sharedModelVendor
            else { throw SlackModelTypeVendorError.noStorageConfigured }

        return try shared.model(id: id)
    }
}
