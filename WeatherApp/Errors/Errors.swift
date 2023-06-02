
import Foundation

enum Errors: Error {
    case empty
    case unexpected
    case singleLocation
}

extension Errors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .empty:
            return NSLocalizedString("It looks like you left an empty field",
                                     comment: "")
        case .unexpected:
            return NSLocalizedString("Something went wrong",
                                     comment: "")
        case .singleLocation:
            return NSLocalizedString("Unable to delete a single location", comment: "")
        }
    }
}
