import SwiftUI
import UIKit

struct CropView: View {
    @Environment(AppEnvironment.self) private var environment
    @Environment(\.dismiss) private var dismiss

    let originalImage: UIImage
    let onCompleted: () -> Void

    @State private var viewModel: CropViewModel?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                if let viewModel {
                    editor(viewModel)

                    if viewModel.isProcessing {
                        processingOverlay
                    }
                } else {
                    ProgressView()
                        .tint(.white)
                }
            }
            .navigationTitle("调整名片边界")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(AppCopy.cancel) { dismiss() }
                        .foregroundStyle(.white)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if let viewModel {
                        Button(AppCopy.rotate) { viewModel.rotate() }
                            .foregroundStyle(.white)
                            .accessibilityIdentifier("BizScan.Crop.Rotate")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(AppCopy.next) { viewModel?.process() }
                        .foregroundStyle(.white)
                        .disabled(viewModel?.isProcessing ?? true)
                        .accessibilityIdentifier("BizScan.Crop.Confirm")
                }
            }
            .toolbarBackground(.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .task {
            if viewModel == nil {
                let model = CropViewModel(
                    originalImage: originalImage,
                    pipeline: environment.makePipeline()
                )
                viewModel = model
                model.detectIfNeeded()
            }
        }
        .fullScreenCover(
            isPresented: Binding(
                get: { viewModel?.result != nil },
                set: { if !$0 { viewModel?.result = nil } }
            )
        ) {
            if let result = viewModel?.result {
                ReviewView(scanResult: result, onSaved: onCompleted)
            }
        }
        .alert(
            AppCopy.errorTitle,
            isPresented: Binding(
                get: { viewModel?.errorMessage != nil },
                set: { if !$0 { viewModel?.errorMessage = nil } }
            )
        ) {
            Button(AppCopy.done, role: .cancel) { viewModel?.errorMessage = nil }
        } message: {
            Text(viewModel?.errorMessage ?? "")
        }
    }

    private func editor(_ viewModel: CropViewModel) -> some View {
        GeometryReader { geometry in
            let layout = ImageLayout(imageSize: originalImage.size, container: geometry.size)

            ZStack {
                Image(uiImage: originalImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height)

                Path { path in
                    guard let first = viewModel.points.first else { return }
                    path.move(to: layout.point(first))
                    for point in viewModel.points.dropFirst() {
                        path.addLine(to: layout.point(point))
                    }
                    path.closeSubpath()
                }
                .stroke(Color.accentColor, lineWidth: 2)

                ForEach(viewModel.points.indices, id: \.self) { index in
                    Circle()
                        .fill(Color.accentColor)
                        .overlay(Circle().stroke(.white, lineWidth: 2))
                        .frame(width: 22, height: 22)
                        .position(layout.point(viewModel.points[index]))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    viewModel.movePoint(at: index, to: layout.normalized(value.location))
                                }
                        )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .padding(16)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 6) {
                if let confidence = viewModel.detectionConfidence {
                    Text(String(format: "自动检测置信度 %.2f", confidence))
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                } else {
                    Text("未检测到边界，请手动调整四个角")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }
                if viewModel.rotationQuarterTurns != 0 {
                    Text("输出将旋转 \(viewModel.rotationQuarterTurns * 90)°")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            .padding(.bottom, 8)
        }
    }

    private var processingOverlay: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            VStack(spacing: 12) {
                ProgressView()
                    .tint(.white)
                Text(AppCopy.processing)
                    .foregroundStyle(.white)
            }
        }
    }
}

/// 把归一化坐标映射到屏幕上的图像矩形。
private struct ImageLayout {
    let rect: CGRect

    init(imageSize: CGSize, container: CGSize) {
        guard imageSize.width > 0, imageSize.height > 0 else {
            rect = .zero
            return
        }
        let scale = min(container.width / imageSize.width, container.height / imageSize.height)
        let size = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
        rect = CGRect(
            x: (container.width - size.width) / 2,
            y: (container.height - size.height) / 2,
            width: size.width,
            height: size.height
        )
    }

    func point(_ normalized: CGPoint) -> CGPoint {
        CGPoint(
            x: rect.minX + normalized.x * rect.width,
            y: rect.minY + normalized.y * rect.height
        )
    }

    func normalized(_ point: CGPoint) -> CGPoint {
        guard rect.width > 0, rect.height > 0 else { return .zero }
        return CGPoint(
            x: (point.x - rect.minX) / rect.width,
            y: (point.y - rect.minY) / rect.height
        )
    }
}
