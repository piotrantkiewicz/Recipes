import Foundation

extension LocalRecipeDataSourceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let fileName):
            return "\(fileName) \("error.file-not-found".localized)"
        }
    }
}
