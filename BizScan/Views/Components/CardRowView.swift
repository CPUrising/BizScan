import SwiftUI
import UIKit
import BizScanCore

struct CardRowView: View {
    let card: BusinessCard
    let thumbnail: UIImage?

    var body: some View {
        HStack(spacing: 12) {
            thumbnailView
            VStack(alignment: .leading, spacing: 4) {
                Text(card.displayTitle(fallback: AppCopy.unnamedCard))
                    .font(.headline)
                    .lineLimit(1)
                if let subtitle = card.displaySubtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 4)
        .accessibilityIdentifier("BizScan.CardRow.\(card.id.uuidString)")
    }

    @ViewBuilder
    private var thumbnailView: some View {
        Group {
            if let thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Color(uiColor: .secondarySystemBackground)
                    Image(systemName: "person.text.rectangle")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(width: 64, height: 40)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct EmptyStateView: View {
    let onScan: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.text.rectangle")
                .font(.system(size: 56))
                .foregroundStyle(.secondary)
            Text(AppCopy.emptyTitle)
                .font(.title3.weight(.semibold))
            Text(AppCopy.emptyMessage)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button(action: onScan) {
                Label(AppCopy.scanCard, systemImage: "camera.fill")
            }
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier("BizScan.Home.EmptyScan")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityIdentifier("BizScan.Home.EmptyState")
    }
}
