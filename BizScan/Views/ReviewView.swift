import SwiftUI
import UIKit

struct ReviewView: View {
    @Environment(AppEnvironment.self) private var environment
    @Environment(\.dismiss) private var dismiss

    let scanResult: ScanResult
    let onSaved: () -> Void

    @State private var viewModel: ReviewViewModel?
    @State private var setupError: String?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    form(viewModel)
                        .confirmationDialog(
                            AppCopy.saveEmptyWarning,
                            isPresented: Binding(
                                get: { viewModel.showsEmptyWarning },
                                set: { viewModel.showsEmptyWarning = $0 }
                            ),
                            titleVisibility: .visible
                        ) {
                            Button(AppCopy.save, role: .destructive) {
                                viewModel.save(force: true)
                            }
                            Button(AppCopy.cancel, role: .cancel) {}
                        }
                } else if let setupError {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundStyle(.orange)
                        Text("无法准备校正页")
                            .font(.headline)
                        Text(setupError)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                        Button(AppCopy.back) { dismiss() }
                            .buttonStyle(.bordered)
                    }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle(AppCopy.reviewTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(AppCopy.cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(AppCopy.save) { viewModel?.save() }
                        .disabled(viewModel?.isSaving ?? true)
                        .accessibilityIdentifier("BizScan.Review.Save")
                }
            }
        }
        .task { setupIfNeeded() }
        .onChange(of: viewModel?.didSave) { _, saved in
            guard saved == true else { return }
            dismiss()
            onSaved()
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

    private func form(_ viewModel: ReviewViewModel) -> some View {
        @Bindable var viewModel = viewModel

        return Form {
            Section {
                HStack {
                    Spacer()
                    Image(uiImage: viewModel.previewImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    Spacer()
                }
            }

            Section("基本信息") {
                TextField("姓名", text: $viewModel.name)
                    .accessibilityIdentifier("BizScan.Review.Name")
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
                    .keyboardType(.numbersAndPunctuation)
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

            if !viewModel.unresolvedLines.isEmpty {
                Section(AppCopy.unknownFieldsTitle) {
                    ForEach(viewModel.unresolvedLines, id: \.self) { line in
                        Text(line)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section {
                Text(AppCopy.reviewMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func setupIfNeeded() {
        guard viewModel == nil, setupError == nil else { return }
        do {
            viewModel = try ReviewViewModel(
                scanResult: scanResult,
                repository: environment.repository,
                imageStore: environment.imageStore
            )
        } catch {
            setupError = error.localizedDescription
        }
    }
}
