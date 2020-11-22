enum TimePart: String, CaseIterable, Equatable {
    case min = "Minute"
    case hour = "Hour"
    case day = "Day"
    case week = "Week"
    case month = "Month"
    case year = "Year"
    
    func seconds() -> Double {
        switch self {
        case .min:
            return 60
        case .hour:
            return 60 * 60
        case .day:
            return 60 * 60 * 24
        case .week:
            return 60 * 60 * 24 * 7
        case .month:
            return 60 * 60 * 24 * 365 / 12
        case .year:
            return 60 * 60 * 24 * 365
        }
    }
    
    func max() -> Int {
        switch self {
        case .min:
            return 60
        case .hour:
            return 24
        case .day:
            return 365
        case .week:
            return 52
        case .month:
            return 36
        case .year:
            return 100
        }
    }
}
