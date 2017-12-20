
public typealias ErrorHandler = (Error) -> Void

public func defaultErrorHandler(_ error: Error) {
    print("ERROR: \(error)")
}
