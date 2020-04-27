extension Parser where T: LosslessStringConvertible {
    public static func literal(_ value: T) -> Parser {
        return .init { input in
            let valueString = String(describing: value)

            var inputIterator = input.indices.makeIterator()
            var valueIterator = valueString.indices.makeIterator()

            while let inputIndex = inputIterator.next(), let valueIndex = valueIterator.next() {
                guard input[inputIndex] == valueString[valueIndex] else { return nil }

                if valueIndex == valueString.index(before: valueString.endIndex) {
                    return (value, input[input.index(after: inputIndex)...])
                }
            }

            return nil
        }
    }
}

extension Parser: ExpressibleByStringLiteral, ExpressibleByUnicodeScalarLiteral, ExpressibleByExtendedGraphemeClusterLiteral
    where T == String
{
    public typealias UnicodeScalarLiteralType = String
    public typealias ExtendedGraphemeClusterLiteralType = String

    public init(stringLiteral value: String) {
        self = .literal(value)
    }
}
