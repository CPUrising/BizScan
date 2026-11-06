import SwiftUI
import UIKit
import BizScanCore

struct DetailView: View {
    @Environment(AppEnvironment.self) private var environment
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    let cardID: UUID

    @State private var viewModel: DetailViewModel?
    @State private var isDeleteConfirmPresented = false
    @State private var shareURL: URL?
    @State private var isSharePresented = false
    @State private var isImageViewerPresented = false

    var body: some View {
        Group {
            if let viewModel, viewModel.card != nil {
                content(viewModel)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Theme.pageDetail)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .task {
            if viewModel == nil {
                viewModel = DetailViewModel(
                    cardID: cardID,
                    repository: environment.repository,
                    imageStore: environment.imageStore
                )
            }
            viewModel?.load()
        }
        .onChange(of: viewModel?.didDelete) { _, deleted in
            if deleted == true {
                dismiss()
            }
        }
        .confirmationDialog(
            AppCopy.deleteConfirmTitle,
            isPresented: $isDeleteConfirmPresented,
            titleVisibility: .visible
        ) {
            Button(AppCopy.delete, role: .destructive) {
                viewModel?.delete()
            }
            Button(AppCopy.cancel, role: .cancel) {}
        } message: {
            Text(AppCopy.deleteConfirmMessage)
        }
        .sheet(
            isPresented: Binding(
                get: { viewModel?.isEditing ?? false },
                set: { if !$0 { viewModel?.cancelEditing() } }
            )
        ) {
            if let viewModel {
                EditCardView(viewModel: viewModel)
            }
        }
        .sheet(isPresented: $isSharePresented) {
            if let shareURL {
                ShareSheet(items: [shareURL])
            }
        }
        .fullScreenCover(isPresented: $isImageViewerPresented) {
            if let image = viewModel?.image() {
                CardImageViewer(image: image)
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

    private func content(_ viewModel: DetailViewModel) -> some View {
        VStack(spacing: 0) {
            topBar(viewModel)
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 8) {
                        profileCard(viewModel, proxy: proxy)
                        groupRow(viewModel)
                        if let notes = viewModel.notesText {
                            notesCard(notes)
                                .id("detail-notes")
                        }
                        if !viewModel.contactEntries.isEmpty {
                            contactSection(viewModel)
                        }
                    }
                    .padding(.bottom, 8)
                }
                .scrollIndicators(.hidden)
                .background(Theme.pageDetail)
            }
        }
        .background(Theme.pageDetail)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            footer
        }
    }

    // MARK: - 顶栏

    private func topBar(_ viewModel: DetailViewModel) -> some View {
        HStack(spacing: 0) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Theme.textPrimaryDetail)
                    .frame(width: 26, height: 26)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("BizScan.Detail.Back")

            Spacer(minLength: 0)

            Text(AppCopy.detailTitle)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Theme.textPrimaryDetail)

            Spacer(minLength: 0)

            HStack(spacing: 20) {
                Button {
                    viewModel.toggleFavorite()
                } label: {
                    Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(Theme.textPrimaryDetail)
                        .frame(width: 22, height: 22)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("BizScan.Detail.Favorite")
                .accessibilityValue(viewModel.isFavorite ? "已收藏" : "未收藏")

                Menu {
                    Button {
                        exportCard()
                    } label: {
                        Label(AppCopy.export, systemImage: "square.and.arrow.up")
                    }
                    Button(role: .destructive) {
                        isDeleteConfirmPresented = true
                    } label: {
                        Label(AppCopy.delete, systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(Theme.textPrimaryDetail)
                        .frame(width: 24, height: 24)
                        .contentShape(Rectangle())
                }
                .accessibilityIdentifier("BizScan.Detail.More")
            }
        }
        .padding(.horizontal, 18)
        .frame(height: 56)
        .background(Theme.navBlue)
    }

    // MARK: - 核心资料

    private func profileCard(_ viewModel: DetailViewModel, proxy: ScrollViewProxy) -> some View {
        VStack(alignment: .leading, spacing: 19) {
            HStack(alignment: .center, spacing: 16) {
                Text(viewModel.avatarInitial)
                    .font(.system(size: 32))
                    .foregroundStyle(Theme.textPrimaryDetail)
                    .frame(width: 66, height: 66)
                    .background(Circle().fill(Theme.green))
                    .accessibilityIdentifier("BizScan.Detail.Avatar")

                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.displayName)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(Theme.textPrimaryDetail)
                        .lineLimit(2)
                        .accessibilityIdentifier("BizScan.Detail.Name")
                    if let subtitle = viewModel.subtitle {
                        Text(subtitle)
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.textSecondaryDetail)
                    }
                }

                Spacer(minLength: 8)

                if viewModel.hasImage {
                    Button {
                        isImageViewerPresented = true
                    } label: {
                        VStack(spacing: 5) {
                            Image(systemName: "person.text.rectangle")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(Theme.greenLight)
                                .frame(width: 42, height: 34)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .stroke(Theme.green, lineWidth: 1)
                                )
                            Text(AppCopy.viewOriginal)
                                .font(.system(size: 11))
                                .foregroundStyle(Theme.greenLight)
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("BizScan.Detail.Original")
                }
            }

            if let company = viewModel.companyName {
                Text(company)
                    .font(.system(size: 15))
                    .foregroundStyle(Theme.textSecondaryDetail)
                    .accessibilityIdentifier("BizScan.Detail.Company")
            }

            HStack(spacing: 20) {
                quickAction(
                    title: AppCopy.actionPhone,
                    symbol: "phone",
                    color: Theme.green,
                    enabled: viewModel.primaryPhoneURL != nil,
                    identifier: "BizScan.Detail.Quick.Phone"
                ) {
                    if let url = viewModel.primaryPhoneURL { openURL(url) }
                }
                quickAction(
                    title: AppCopy.actionAddress,
                    symbol: "mappin.and.ellipse",
                    color: Theme.navBlue,
                    enabled: viewModel.mapsURL != nil,
                    identifier: "BizScan.Detail.Quick.Address"
                ) {
                    if let url = viewModel.mapsURL { openURL(url) }
                }
                quickAction(
                    title: AppCopy.actionNotes,
                    symbol: "message",
                    color: Theme.amber,
                    enabled: viewModel.notesText != nil,
                    identifier: "BizScan.Detail.Quick.Notes"
                ) {
                    withAnimation { proxy.scrollTo("detail-notes", anchor: .top) }
                }
                quickAction(
                    title: AppCopy.edit,
                    symbol: "square.and.pencil",
                    color: Theme.purple,
                    enabled: true,
                    identifier: "BizScan.Detail.Quick.Edit"
                ) {
                    viewModel.beginEditing()
                }
            }
        }
        .padding(.top, 28)
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.surface)
    }

    private func quickAction(
        title: String,
        symbol: String,
        color: Color,
        enabled: Bool,
        identifier: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 9) {
                Image(systemName: symbol)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(Theme.textPrimaryDetail)
                    .frame(width: 48, height: 48)
                    .background(Circle().fill(enabled ? color : Theme.dividerStrong))
                Text(title)
                    .font(.system(size: 13))
                    .foregroundStyle(enabled ? Theme.textSecondaryDetail : Theme.textTertiaryDetail)
            }
            .frame(width: 70)
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .accessibilityIdentifier(identifier)
    }

    // MARK: - 分组 / 备注 / 联系方式

    private func groupRow(_ viewModel: DetailViewModel) -> some View {
        HStack(spacing: 16) {
            Image(systemName: "person.crop.circle")
                .font(.system(size: 17))
                .foregroundStyle(Theme.textTertiaryDetail)
                .frame(width: 20, height: 20)
            Text(viewModel.groupDisplayName)
                .font(.system(size: 15))
                .foregroundStyle(Theme.textSecondaryDetail)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 24)
        .frame(height: 56)
        .background(Theme.surface)
        .accessibilityIdentifier("BizScan.Detail.Group")
    }

    private func notesCard(_ notes: String) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(AppCopy.notesTitle)
                .font(.system(size: 12))
                .foregroundStyle(Theme.textTertiaryDetail)
            Text(notes)
                .font(.system(size: 14))
                .foregroundStyle(Theme.textSecondaryDetail)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 24)
        .padding(.top, 18)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.surface)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Theme.dividerStrong)
                .frame(height: 1)
        }
        .accessibilityIdentifier("BizScan.Detail.Notes")
    }

    private func contactSection(_ viewModel: DetailViewModel) -> some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.contactEntries.enumerated()), id: \.element.id) { index, entry in
                contactRow(viewModel, entry: entry)
                if index < viewModel.contactEntries.count - 1 {
                    Rectangle()
                        .fill(Theme.dividerStrong)
                        .frame(height: 1)
                }
            }
        }
        .padding(.horizontal, 24)
        .background(Theme.surface)
    }

    private func contactRow(_ viewModel: DetailViewModel, entry: ContactEntry) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: entry.kind.symbolName)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Theme.textTertiaryDetail)
                .frame(width: 20, height: 24)
                .padding(.top, 18)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text(entry.kind.title)
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.textTertiaryDetail)
                    if let badge = entry.kind.badge {
                        Text(badge)
                            .font(.system(size: 12))
                            .foregroundStyle(Theme.textSecondaryDetail)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(Theme.control)
                            )
                    }
                    if entry.needsReview {
                        Text(AppCopy.reviewBadge)
                            .font(.system(size: 12))
                            .foregroundStyle(Theme.amber)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(Theme.amberSurface)
                            )
                            .accessibilityIdentifier("BizScan.Detail.ReviewBadge.\(entry.id)")
                    }
                }

                Button {
                    if let url = viewModel.actionURL(for: entry) {
                        openURL(url)
                    }
                } label: {
                    Text(entry.value)
                        .font(.system(size: 16))
                        .foregroundStyle(Theme.textPrimaryDetail)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)
                .disabled(viewModel.actionURL(for: entry) == nil)

                if entry.needsReview {
                    Text(AppCopy.reviewHint)
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.textTertiaryDetail)
                }
            }
            .padding(.vertical, 18)

            if entry.kind.isPhone {
                Button {
                    viewModel.beginEditing()
                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 15))
                        .foregroundStyle(Theme.textSecondaryDetail)
                        .frame(width: 18, height: 18)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.top, 35)
                .accessibilityIdentifier("BizScan.Detail.EditContact.\(entry.id)")
            }
        }
        .accessibilityIdentifier("BizScan.Detail.Contact.\(entry.id)")
    }

    // MARK: - 底部

    private var footer: some View {
        Button {
            // 0022 接入系统通讯录
        } label: {
            Text(AppCopy.saveToContacts)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Theme.textPrimaryDetail)
                .frame(maxWidth: .infinity)
                .frame(height: 47)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Theme.green.opacity(0.4))
                )
        }
        .buttonStyle(.plain)
        .disabled(true)
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Theme.surface)
        .accessibilityIdentifier("BizScan.Detail.SaveToContacts")
    }

    private func exportCard() {
        guard let card = viewModel?.card else { return }
        do {
            shareURL = try environment.vcardExporter.export([card])
            isSharePresented = true
        } catch {
            viewModel?.errorMessage = error.localizedDescription
        }
    }
}

private struct EditCardView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: DetailViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section("基本信息") {
                    TextField("姓名", text: $viewModel.name)
                        .accessibilityIdentifier("BizScan.Edit.Name")
                    TextField("公司", text: $viewModel.company)
                        .accessibilityIdentifier("BizScan.Edit.Company")
                    TextField("职位", text: $viewModel.jobTitle)
                    TextField("部门", text: $viewModel.department)
                }
                Section("联系方式") {
                    TextField("手机（每行一个）", text: $viewModel.mobilesText, axis: .vertical)
                        .lineLimit(1...3)
                    TextField("办公电话（每行一个）", text: $viewModel.officePhonesText, axis: .vertical)
                        .lineLimit(1...3)
                    TextField("传真（每行一个）", text: $viewModel.faxesText, axis: .vertical)
                        .lineLimit(1...2)
                    TextField("邮箱（每行一个）", text: $viewModel.emailsText, axis: .vertical)
                        .lineLimit(1...3)
                    TextField("网址", text: $viewModel.website)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    TextField("地址", text: $viewModel.address, axis: .vertical)
                        .lineLimit(1...3)
                    TextField("邮编", text: $viewModel.postalCode)
                }
                Section("备注") {
                    TextField("备注", text: $viewModel.notes, axis: .vertical)
                        .lineLimit(2...5)
                }
                Section(AppCopy.tagsTitle) {
                    ForEach(viewModel.tags, id: \.self) { tag in
                        HStack {
                            Text(tag)
                            Spacer()
                            Button {
                                viewModel.removeTag(tag)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    HStack {
                        TextField(AppCopy.addTag, text: $viewModel.newTag)
                        Button(AppCopy.done) { viewModel.addTag() }
                            .disabled(viewModel.newTag.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
            .navigationTitle(AppCopy.edit)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(AppCopy.cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(AppCopy.save) {
                        viewModel.save()
                        dismiss()
                    }
                }
            }
        }
    }
}
