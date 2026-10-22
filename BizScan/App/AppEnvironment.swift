import Foundation
import Observation
import BizScanCore

/// 全应用共享的依赖容器。SwiftData 容器在 App 启动时创建，其余服务无状态。
@Observable
@MainActor
final class AppEnvironment {
    let repository: BusinessCardRepository
    let imageStore: ImageStoring

    init(repository: BusinessCardRepository, imageStore: ImageStoring) {
        self.repository = repository
        self.imageStore = imageStore
        self.cardDetector = VisionCardDetector()
        self.imageCorrector = CoreImageCorrector()
        self.ocrService = VisionOCRService()
        self.vcardExporter = VCardFileExporter()
    }

    let cardDetector: CardDetecting
    let imageCorrector: ImageCorrecting
    let ocrService: OCRRecognizing
    let vcardExporter: VCardExporting

    func makePipeline() -> ScanPipeline {
        ScanPipeline(
            detector: cardDetector,
            corrector: imageCorrector,
            ocr: ocrService
        )
    }
}
