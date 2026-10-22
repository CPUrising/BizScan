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

    var body: some View {
        Group {
            if let viewModel, let card = viewModel.card {
                content(viewModel, card: card)
            } else {
                ProgressView()
            }
        }
        .navigationTitle(AppCopy.detailTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(AppCopy.edit) {
                    viewModel?.beginEditing()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
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
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
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

    private func content(_ viewModel: DetailViewModel, card: BusinessCard) -> some View {
        List {
            if let image = viewModel.image() {
                Section {
                    HStack {
                        Spacer()
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Spacer()
                    }
                }
            }

            Section {
                ForEach(viewModel.displayRows.indices, id: \.self) { index in
                    let row = viewModel.displayRows[index]
                    rowView(label: row.0, value: row.1)
                }
            }

            if !card.tags.isEmpty {
                Section(AppCopy.tagsTitle) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(card.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.footnote)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.accentColor.opacity(0.15))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    @ViewBuilder
    private func rowView(label: String, value: String) -> some View {
        if let url = actionURL(for: label, value: value) {
            Button {
                openURL(url)
            } label: {
                HStack(alignment: .firstTextBaseline) {
                    Text(label)
                        .foregroundStyle(.secondary)
                    Spacer(minLength: 16)
                    Text(value)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(.tint)
                }
            }
            .buttonStyle(.plain)
        } else {
            HStack(alignment: .firstTextBaseline) {
                Text(label)
                    .foregroundStyle(.secondary)
                Spacer(minLength: 16)
                Text(value)
                    .multilineTextAlignment(.trailing)
            }
        }
    }

    private func actionURL(for label: String, value: String) -> URL? {
        switch label {
        case "手机", "办公电话", "传真":
            let digits = value.filter { "0123456789+".contains($0) }
            return digits.isEmpty ? nil : URL(string: "tel://\(digits)")
        case "邮箱":
            return URL(string: "mailto:\(value)")
        case "网址":
            let normalized = value.contains("://") ? value : "https://\(value)"
            return URL(string: normalized)
        default:
            return nil
        }
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
                    TextField("公司", text: $viewModel.company)
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
