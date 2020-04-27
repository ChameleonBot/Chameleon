extension ElementMatcher {
    public func map<T, U>(_ value: @escaping (T) -> U) -> ElementMatcher {
        return .init { elements in
            switch self.match(elements) {
            case let match?:
                guard let matchValue = match.values.first as? T else { return nil }
                return ([value(matchValue)], match.remaining)
            case nil:
                return nil
            }
        }
    }

    public func map<T>(_ value: @autoclosure @escaping () -> T) -> ElementMatcher {
        return .init { elements in
            switch self.match(elements) {
            case let match?:
                return ([value()], match.remaining)
            case nil:
                return nil
            }
        }
    }
    
    public func map<T>(_ values: @autoclosure @escaping () -> [T]) -> ElementMatcher {
        return .init { elements in
            switch self.match(elements) {
            case let match?:
                return (values(), match.remaining)
            case nil:
                return nil
            }
        }
    }
}
