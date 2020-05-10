extension Parser {
    public static var user: Parser<Identifier<User>> {
        let endWithName = ("|" <*> ">").void
        let end = Parser<String>.literal(">").void
        let identifier = .literal("<@") <*> (endWithName || end)
        return identifier.map(Identifier<User>.init(rawValue:))
    }

    public static func user(_ identifier: Identifier<User>) -> Parser<Identifier<User>> {
        let endWithName = ("|" <*> ">").void
        let end = Parser<String>.literal(">").void
        return (.literal("<@\(identifier.rawValue)") <* (endWithName || end)).map { _ in identifier }
    }
}

extension Parser {
    public static var channel: Parser<Identifier<Channel>> {
        let endWithName = ("|" <*> ">").void
        let end = Parser<String>.literal(">").void
        let identifier = .literal("<#") <*> (endWithName || end)
        return identifier.map(Identifier<Channel>.init(rawValue:))
    }

    public static func channel(_ identifier: Identifier<Channel>) -> Parser<Identifier<Channel>> {
        let endWithName = ("|" <*> ">").void
        let end = Parser<String>.literal(">").void
        return (.literal("<#\(identifier.rawValue)") <* (endWithName || end)).map { _ in identifier }
    }
}
