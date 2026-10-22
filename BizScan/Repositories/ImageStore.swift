import Foundation
import UIKit

enum ImageStoreError: LocalizedError {
    case writeFailed

    var errorDescription: String? {
        switch self {
        case .writeFailed:
            return "名片图片写入失败，请检查设备存储空间。"
        }
    }
}

enum StoredImageKind: String {
    case original
    case processed
}

/// 图像以相对路径持久化，模型不保存绝对路径。
protocol ImageStoring {
    func saveImageData(_ data: Data, cardID: UUID, kind: StoredImageKind) throws -> String
    func data(forRelativePath path: String) -> Data?
    func image(forRelativePath path: String) -> UIImage?
    func delete(relativePath: String)
}

final class FileImageStore: ImageStoring {
    private let baseURL: URL
    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        let support = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? fileManager.temporaryDirectory
        self.baseURL = support
        try? fileManager.createDirectory(
            at: support.appendingPathComponent("CardImages", isDirectory: true),
            withIntermediateDirectories: true
        )
    }

    func url(forRelativePath path: String) -> URL {
        baseURL.appendingPathComponent(path)
    }

    func saveImageData(_ data: Data, cardID: UUID, kind: StoredImageKind) throws -> String {
        let relativePath = "CardImages/\(cardID.uuidString)-\(kind.rawValue).jpg"
        let url = self.url(forRelativePath: relativePath)
        try fileManager.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        guard fileManager.createFile(atPath: url.path, contents: data) else {
            throw ImageStoreError.writeFailed
        }
        return relativePath
    }

    func data(forRelativePath path: String) -> Data? {
        try? Data(contentsOf: url(forRelativePath: path))
    }

    func image(forRelativePath path: String) -> UIImage? {
        UIImage(contentsOfFile: url(forRelativePath: path).path)
    }

    func delete(relativePath: String) {
        guard !relativePath.isEmpty else { return }
        try? fileManager.removeItem(at: url(forRelativePath: relativePath))
    }
}

/// 测试与 Preview 用的内存实现，不触碰磁盘。
final class InMemoryImageStore: ImageStoring {
    private(set) var storage: [String: Data] = [:]

    func saveImageData(_ data: Data, cardID: UUID, kind: StoredImageKind) throws -> String {
        let path = "memory/\(cardID.uuidString)-\(kind.rawValue).jpg"
        storage[path] = data
        return path
    }

    func data(forRelativePath path: String) -> Data? {
        storage[path]
    }

    func image(forRelativePath path: String) -> UIImage? {
        guard let data = storage[path] else { return nil }
        return UIImage(data: data)
    }

    func delete(relativePath: String) {
        storage.removeValue(forKey: relativePath)
    }
}
