public struct CalendarDate: Codable, Equatable {
    public var year: Int
    public var month: Int
    public var day: Int

    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        let values = value.components(separatedBy: "-")

        guard values.count == 3 else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Value '\(value)' in not in the format YYYY-MM-DD")
        }

        guard
            let day = Int(values[0]),
            let month = Int(values[1]),
            let year = Int(values[2])
            else { throw DecodingError.dataCorruptedError(in: container, debugDescription: "Value '\(value)' is invalid and was unable to be decoded") }

        self.year = year
        self.month = month
        self.day = day
    }

    public func encode(to encoder: Encoder) throws {
        let value = "\(year)-\(month)-\(day)"
        try value.encode(to: encoder)
    }
}

public struct DatePicker: Codable, Equatable {
    public static let type = "datepicker"

    public var type: String
    public var action_id: String
    public var placeholder: Text.PlainText?
    public var initial_date: CalendarDate?
    public var confirm: Confirmation?
}
