public protocol Emptyable {
    init()

    var isEmpty: Bool { get }
}

extension String: Emptyable { }
extension Array: Emptyable { }

