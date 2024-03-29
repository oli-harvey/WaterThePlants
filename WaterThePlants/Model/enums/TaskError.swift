import Foundation

enum TaskError: Error {
    case dueDateInPast, lastCompleteInFuture, nameEmpty
}

extension TaskError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dueDateInPast:
            return NSLocalizedString("You must enter a due date in the future.", comment: "")
        case .lastCompleteInFuture:
                return NSLocalizedString("You must have a last complete date in the past, or dont add one", comment: "")
        case .nameEmpty:
                return NSLocalizedString("Give the task a name", comment: "")
        }
    }
    public var errorTitle: String? {
        switch self {
        case .dueDateInPast:
            return NSLocalizedString("Due When?", comment: "")
        case .lastCompleteInFuture:
                return NSLocalizedString("That hasnt happened yet", comment: "")
        case .nameEmpty:
                return NSLocalizedString("What do you want to call it?", comment: "")
        }
    }
}
