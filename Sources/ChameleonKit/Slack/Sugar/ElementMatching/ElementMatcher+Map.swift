extension ElementMatcher {
    public func map<T, U>(_ value: @escaping (T) -> U) -> ElementMatcher {
        return .init { elements in
            let match = try self.match(elements)
            guard let matchValue = match.values.first as? T else {
                throw Error.typeMismatch(expected: T.self, value: match.values.first)
            }
            return ([value(matchValue)], match.remaining)
        }
    }

    public func map<T>(_ value: @autoclosure @escaping () -> T) -> ElementMatcher {
        return .init { elements in
            let remaining = try self.match(elements).remaining
            return ([value()], remaining)
        }
    }

    public func map<T>(_ values: @autoclosure @escaping () -> [T]) -> ElementMatcher {
        return .init { elements in
            let remaining = try self.match(elements).remaining
            return (values(), remaining)
        }
    }
}
