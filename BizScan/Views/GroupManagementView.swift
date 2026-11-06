import SwiftUI
import BizScanCore

struct GroupManagementView: View {
    @Environment(AppEnvironment.self) private var environment
    @Environment(\.dismiss) private var dismiss

    @Binding var selectedGroup: String?

    @State private var viewModel: GroupViewModel?
    @State private var isCreating = false
    @State private var newGroupName = ""
    @State private var renamingGroup: String?
    @State private var renameText = ""
    @State private var pendingDelete: String?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    list(viewModel)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle(AppCopy.groupManagement)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(AppCopy.done) { dismiss() }
                        .accessibilityIdentifier("BizScan.Groups.Done")
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        newGroupName = ""
                        isCreating = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("BizScan.Groups.Add")
                }
            }
            .alert(AppCopy.newGroup, isPresented: $isCreating) {
                TextField(AppCopy.groupNamePlaceholder, text: $newGroupName)
                    .accessibilityIdentifier("BizScan.Groups.NameField")
                Button(AppCopy.cancel, role: .cancel) { newGroupName = "" }
                Button(AppCopy.confirm) {
                    if let created = viewModel?.create(newGroupName) {
                        selectedGroup = created
                    }
                    newGroupName = ""
                }
                .accessibilityIdentifier("BizScan.Groups.ConfirmCreate")
            }
            .alert(
                AppCopy.renameGroup,
                isPresented: Binding(
                    get: { renamingGroup != nil },
                    set: { if !$0 { renamingGroup = nil } }
                )
            ) {
                TextField(AppCopy.groupNamePlaceholder, text: $renameText)
                Button(AppCopy.cancel, role: .cancel) { renamingGroup = nil }
                Button(AppCopy.confirm) {
                    if let group = renamingGroup {
                        viewModel?.rename(group, to: renameText)
                        if selectedGroup?.caseInsensitiveCompare(group) == .orderedSame {
                            selectedGroup = nil
                        }
                    }
                    renamingGroup = nil
                }
            }
            .confirmationDialog(
                AppCopy.deleteGroupConfirmTitle,
                isPresented: Binding(
                    get: { pendingDelete != nil },
                    set: { if !$0 { pendingDelete = nil } }
                ),
                titleVisibility: .visible
            ) {
                Button(AppCopy.delete, role: .destructive) {
                    if let group = pendingDelete {
                        viewModel?.delete(group)
                        if selectedGroup?.caseInsensitiveCompare(group) == .orderedSame {
                            selectedGroup = nil
                        }
                    }
                    pendingDelete = nil
                }
                Button(AppCopy.cancel, role: .cancel) { pendingDelete = nil }
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
                viewModel = GroupViewModel(repository: environment.repository)
            }
            viewModel?.reload()
        }
    }

    private func list(_ viewModel: GroupViewModel) -> some View {
        List {
            Section {
                row(
                    title: AppCopy.allGroups,
                    count: viewModel.count(for: nil),
                    selected: selectedGroup == nil,
                    identifier: "BizScan.Groups.All"
                ) {
                    selectedGroup = nil
                    dismiss()
                }
            }

            Section(AppCopy.groupTitle) {
                if viewModel.groups.isEmpty {
                    Text("还没有分组")
                        .foregroundStyle(.secondary)
                }
                ForEach(viewModel.groups, id: \.self) { group in
                    row(
                        title: group,
                        count: viewModel.count(for: group),
                        selected: selectedGroup?.caseInsensitiveCompare(group) == .orderedSame,
                        identifier: "BizScan.Groups.Row.\(group)"
                    ) {
                        selectedGroup = group
                        dismiss()
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            pendingDelete = group
                        } label: {
                            Label(AppCopy.deleteGroup, systemImage: "trash")
                        }
                        Button {
                            renameText = group
                            renamingGroup = group
                        } label: {
                            Label(AppCopy.renameGroup, systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .accessibilityIdentifier("BizScan.Groups.Manage")
    }

    private func row(
        title: String,
        count: Int,
        selected: Bool,
        identifier: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundStyle(.primary)
                Spacer()
                Text("\(count)")
                    .foregroundStyle(.secondary)
                if selected {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.tint)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(identifier)
    }
}
