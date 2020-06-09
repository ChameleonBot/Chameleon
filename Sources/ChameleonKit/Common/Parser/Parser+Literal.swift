extension Parser where T: LosslessStringConvertible {
    public static func literal(_ value: T) -> Parser {
        return .init { input in
            let valueString = String(describing: value)

            var inputIterator = input.indices.makeIterator()
            var valueIterator = valueString.indices.makeIterator()

            while let inputIndex = inputIterator.next(), let valueIndex = valueIterator.next() {
                guard input[inputIndex].lowercased() == valueString[valueIndex].lowercased() else {
                    throw ParserError.matchFailed(
                        name: "literal(\(valueString))",
                        reason: "Match Failed at: '\(input[...inputIndex])': Character mismatch '\(input[inputIndex])' != '\(valueString[valueIndex])'"
                    )
                }

                if valueIndex == valueString.index(before: valueString.endIndex) {
                    return (value, input[input.index(after: inputIndex)...])
                }
            }

            throw ParserError.matchFailed(
                name: "literal(\(valueString))",
                reason: "Failed to match '\(valueString)' from '\(input)'"
            )
        }
    }
}

extension Parser: ExpressibleByBooleanLiteral where T == Bool {
    public init(booleanLiteral value: Bool) {
        self = .literal(value)
    }
}

extension Parser: ExpressibleByIntegerLiteral where T == Int {
    public init(integerLiteral value: Int) {
        self = .literal(value)
    }
}

extension Parser: ExpressibleByUnicodeScalarLiteral where T == String {
    public typealias UnicodeScalarLiteralType = String
}
extension Parser: ExpressibleByExtendedGraphemeClusterLiteral where T == String {
    public typealias ExtendedGraphemeClusterLiteralType = String
}

extension Parser: ExpressibleByStringLiteral where T == String {
    public init(stringLiteral value: String) {
        self = .literal(value)
    }
}
