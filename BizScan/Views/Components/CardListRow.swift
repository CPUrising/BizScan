import SwiftUI
import UIKit
import BizScanCore

/// 主页列表行：98×64 缩略图 + 姓名 + 职位/公司 + 更多菜单（Figma 名片主页）。
struct CardListRow: View {
    let card: BusinessCard
    let thumbnail: UIImage?
    let onMove: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            NavigationLink(value: card.id) {
                HStack(spacing: 12) {
                    thumbnailView
                    VStack(alignment: .leading, spacing: 3) {
                        Text(card.displayTitle(fallback: AppCopy.unnamedCard))
                            .font(.system(size: 19, weight: .medium))
                            .foregroundStyle(Theme.textPrimary)
                            .lineLimit(1)
                        subtitle
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("BizScan.CardRow.\(card.id.uuidString)")

            Menu {
                Button {
                    onMove()
                } label: {
                    Label(AppCopy.moveToGroup, systemImage: "folder")
                }
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label(AppCopy.delete, systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Theme.textSecondary)
                    .frame(width: 24, height: 44)
                    .contentShape(Rectangle())
            }
            .accessibilityIdentifier("BizScan.CardRow.Menu.\(card.name ?? card.id.uuidString)")
        }
        .padding(.horizontal, Theme.Layout.screenPadding)
        .frame(height: Theme.Layout.rowHeight)
    }

    @ViewBuilder
    private var subtitle: some View {
        if let jobTitle = card.jobTitle {
            Text(jobTitle)
                .font(.system(size: 14))
                .foregroundStyle(Theme.textSecondary)
                .lineLimit(1)
        }
        if let company = card.company {
            Text(company)
                .font(.system(size: 14))
                .foregroundStyle(Theme.textSecondary)
                .lineLimit(1)
        }
        if card.jobTitle == nil, card.company == nil, let fallback = card.displaySubtitle {
            Text(fallback)
                .font(.system(size: 14))
                .foregroundStyle(Theme.textSecondary)
                .lineLimit(1)
        }
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
                    Theme.control
                    Image(systemName: "person.text.rectangle")
                        .font(.system(size: 22))
                        .foregroundStyle(Theme.textTertiary)
                }
            }
        }
        .frame(width: 98, height: 64)
        .clipShape(RoundedRectangle(cornerRadius: 7))
    }
}

struct HomeEmptyState: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.text.rectangle")
                .font(.system(size: 46, weight: .light))
                .foregroundStyle(Theme.placeholder)
                .frame(width: 64, height: 48)
            Text(AppCopy.homeEmptyHint)
                .font(.system(size: 14))
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityIdentifier("BizScan.Home.EmptyState")
    }
}
