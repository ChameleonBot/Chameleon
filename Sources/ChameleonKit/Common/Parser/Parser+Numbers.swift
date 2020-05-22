extension Parser {
    public static var integer: Parser<Int> {
        let parser = Parser.char("-").optional && .positiveInteger
        return parser.map { $0 == nil ? $1 : $1 * -1 }
    }
    public static var positiveInteger: Parser<Int> {
        let notANumber = char(where: { !$0.isNumber }).void || .end

        return char(where: { $0.isNumber })
            .until(notANumber)
            .map({ $0.0 })
            .string
            .map { Int("\($0)")! }
    }
}
