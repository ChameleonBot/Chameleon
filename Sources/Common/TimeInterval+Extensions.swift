import Foundation

extension TimeInterval {
    var seconds: TimeInterval { return self }

    var minutes: TimeInterval { return self * 60 }

    var hours: TimeInterval { return self.minutes * 60 }

    var days: TimeInterval { return self.hours * 24 }

    var weeks: TimeInterval { return self.days * 7 }
}
