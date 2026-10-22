import Foundation
import BizScanCore

enum ExportError: LocalizedError {
    case noCards
    case encodingFailed
    case writeFailed(String)

    var errorDescription: String? {
        switch self {
        case .noCards:
            return "没有可导出的名片。"
        case .encodingFailed:
            return "联系人数据编码失败。"
        case .writeFailed(let message):
            return "导出文件写入失败：\(message)"
        }
    }
}

protocol VCardExporting {
    func export(_ cards: [BusinessCard]) throws -> URL
}

/// 先落地为临时 .vcf，再交给系统分享面板；不依赖通讯录权限，便于自动化测试。
final class VCardFileExporter: VCardExporting {
    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func export(_ cards: [BusinessCard]) throws -> URL {
        guard !cards.isEmpty else { throw ExportError.noCards }

        let content = VCardBuilder.vCards(for: cards)
        guard let data = content.data(using: .utf8) else {
            throw ExportError.encodingFailed
        }

        let stamp = Int(Date().timeIntervalSince1970)
        let url = fileManager.temporaryDirectory
            .appendingPathComponent("BizScan-\(stamp).vcf")

        do {
            try data.write(to: url, options: .atomic)
        } catch {
            throw ExportError.writeFailed(error.localizedDescription)
        }
        return url
    }
}
