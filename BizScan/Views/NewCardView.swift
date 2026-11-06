import SwiftUI
import BizScanCore

struct NewCardView: View {
    @Environment(AppEnvironment.self) private var environment
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: NewCardViewModel?

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
                } else {
                    ProgressView()
                }
            }
            .navigationTitle(AppCopy.newCard)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(AppCopy.cancel) { dismiss() }
                        .accessibilityIdentifier("BizScan.New.Cancel")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(AppCopy.save) { viewModel?.save() }
                        .disabled(viewModel?.isSaving ?? true)
                        .accessibilityIdentifier("BizScan.New.Save")
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
        .task {
            if viewModel == nil {
                let model = NewCardViewModel(repository: environment.repository)
                model.loadGroups()
                viewModel = model
            }
        }
        .onChange(of: viewModel?.didSave) { _, saved in
            if saved == true { dismiss() }
        }
    }

    private func form(_ viewModel: NewCardViewModel) -> some View {
        @Bindable var viewModel = viewModel

        return Form {
            Section("基本信息") {
                TextField("姓名", text: $viewModel.name)
                    .accessibilityIdentifier("BizScan.New.Name")
                TextField("公司", text: $viewModel.company)
                TextField("职位", text: $viewModel.jobTitle)
                TextField("部门", text: $viewModel.department)
            }

            Section("联系方式") {
                TextField("手机（每行一个）", text: $viewModel.mobilesText, axis: .vertical)
                    .lineLimit(1...3)
                    .accessibilityIdentifier("BizScan.New.Mobile")
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

            Section(AppCopy.groupTitle) {
                Picker(AppCopy.groupTitle, selection: $viewModel.group) {
                    Text(AppCopy.ungrouped).tag(String?.none)
                    ForEach(viewModel.groups, id: \.self) { group in
                        Text(group).tag(Optional(group))
                    }
                }
                .accessibilityIdentifier("BizScan.New.Group")
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

            Section {
                Text("手动新建的名片不会附带名片原图。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
