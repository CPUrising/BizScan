import Foundation
import PhotosUI
import UIKit

enum PhotoImportError: LocalizedError {
    case loadFailed(String?)

    var errorDescription: String? {
        switch self {
        case .loadFailed(let message):
            if let message { return "导入图片失败：\(message)" }
            return "无法读取所选图片，请换一张试试。"
        }
    }
}

struct PhotoLibraryService {
    func loadImage(from item: PhotosPickerItem) async throws -> UIImage {
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else {
                throw PhotoImportError.loadFailed(nil)
            }
            return image
        } catch let error as PhotoImportError {
            throw error
        } catch {
            throw PhotoImportError.loadFailed(error.localizedDescription)
        }
    }
}
