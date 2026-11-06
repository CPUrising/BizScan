import SwiftUI
import UIKit

/// 全屏原图查看：支持双指缩放、下滑关闭与点击关闭。
struct CardImageViewer: View {
    @Environment(\.dismiss) private var dismiss

    let image: UIImage

    @State private var scale: CGFloat = 1
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .scaleEffect(scale)
                .offset(y: dragOffset)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = min(max(value, 1), 4)
                        }
                )
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = max(0, value.translation.height)
                        }
                        .onEnded { value in
                            if value.translation.height > 120 {
                                dismiss()
                            } else {
                                withAnimation { dragOffset = 0 }
                            }
                        }
                )

            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 36, height: 36)
                            .background(Circle().fill(.white.opacity(0.16)))
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("BizScan.ImageViewer.Close")
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                Spacer()
            }
        }
        .statusBarHidden(false)
    }
}
