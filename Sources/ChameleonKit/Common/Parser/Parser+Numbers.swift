extension Parser {
    public static var integer: Parser<Int> {
        let notANumber = char(where: { !$0.isNumber }).void || .end

        return char(where: { $0.isNumber })
            .until(notANumber)
            .map({ $0.0 })
            .string
            .map { Int("\($0)")! }
    }
}
