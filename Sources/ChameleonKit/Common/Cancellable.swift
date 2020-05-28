public struct Cancellable {
    private let _cancel: () -> Void

    public init(_ cancel: @escaping () -> Void) {
        self._cancel = cancel
    }
    public func cancel() { _cancel() }
}
