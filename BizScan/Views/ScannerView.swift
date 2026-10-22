import SwiftUI
import PhotosUI
import UIKit

struct ScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    @State private var viewModel: ScannerViewModel?
    @State private var pickerItem: PhotosPickerItem?
    @State private var isCropPresented = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let viewModel {
                switch viewModel.state {
                case .ready:
                    CameraPreview(session: viewModel.session)
                        .ignoresSafeArea()
                    overlay(viewModel)
                case .denied:
                    permissionView
                case .idle:
                    ProgressView()
                        .tint(.white)
                }
            } else {
                ProgressView()
                    .tint(.white)
            }
        }
        .task {
            if viewModel == nil {
                viewModel = ScannerViewModel()
            }
            await viewModel?.prepare()
        }
        .onDisappear {
            viewModel?.stop()
        }
        .onChange(of: viewModel?.capturedImage) { _, image in
            if image != nil {
                isCropPresented = true
            }
        }
        .onChange(of: pickerItem) { _, item in
            if let item {
                viewModel?.importImage(from: item)
                pickerItem = nil
            }
        }
        .fullScreenCover(isPresented: $isCropPresented, onDismiss: {
            viewModel?.clearCapturedImage()
        }) {
            if let image = viewModel?.capturedImage {
                CropView(originalImage: image) {
                    isCropPresented = false
                    dismiss()
                }
            }
        }
        .alert(
            AppCopy.errorTitle,
            isPresented: Binding(
                get: { viewModel?.errorMessage != nil },
                set: { if !$0 { viewModel?.errorMessage = nil } }
            )
        ) {
            Button(AppCopy.done, role: .cancel) {
                viewModel?.errorMessage = nil
            }
        } message: {
            Text(viewModel?.errorMessage ?? "")
        }
    }

    private func overlay(_ viewModel: ScannerViewModel) -> some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(12)
                        .background(Circle().fill(.black.opacity(0.35)))
                }
                .accessibilityIdentifier("BizScan.Scanner.Close")

                Spacer()

                Text("将名片置于取景框内")
                    .font(.footnote)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(.black.opacity(0.35)))

                Spacer()

                Color.clear.frame(width: 40, height: 40)
            }
            .padding(.horizontal, 16)

            Spacer()

            Rectangle()
                .strokeBorder(.white.opacity(0.7), style: StrokeStyle(lineWidth: 2, dash: [8, 6]))
                .frame(height: 200)
                .padding(.horizontal, 32)

            Spacer()

            HStack {
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    Label(AppCopy.importPhoto, systemImage: "photo.on.rectangle")
                        .font(.footnote)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Capsule().fill(.black.opacity(0.35)))
                }
                .accessibilityIdentifier("BizScan.Scanner.Import")

                Spacer()

                Button {
                    viewModel.capture()
                } label: {
                    ZStack {
                        Circle()
                            .strokeBorder(.white, lineWidth: 4)
                            .frame(width: 76, height: 76)
                        Circle()
                            .fill(.white)
                            .frame(width: 60, height: 60)
                            .opacity(viewModel.isCapturing ? 0.4 : 1)
                    }
                }
                .disabled(viewModel.isCapturing)
                .accessibilityIdentifier("BizScan.Scanner.Shutter")

                Spacer()

                Color.clear.frame(width: 60, height: 40)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
    }

    private var permissionView: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.fill")
                .font(.system(size: 52))
                .foregroundStyle(.white)
            Text(AppCopy.permissionTitle)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
            Text(AppCopy.permissionMessage)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button(AppCopy.openSettings) {
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                openURL(url)
            }
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier("BizScan.Scanner.OpenSettings")

            PhotosPicker(selection: $pickerItem, matching: .images) {
                Text(AppCopy.importPhoto)
                    .font(.subheadline)
            }
            .foregroundStyle(.white)

            Button(AppCopy.back) {
                dismiss()
            }
            .foregroundStyle(.white)
        }
    }
}
