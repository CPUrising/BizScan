import SwiftUI
import UIKit
import BizScanCore

struct HomeView: View {
    @Environment(AppEnvironment.self) private var environment

    @State private var viewModel: HomeViewModel?
    @State private var isScannerPresented = false
    @State private var isSearchPresented = false
    @State private var isNewCardPresented = false
    @State private var isGroupManagementPresented = false
    @State private var pendingDelete: BusinessCard?
    @State private var movingCard: BusinessCard?

    var body: some View {
        NavigationStack {
            content
                .navigationTitle(AppCopy.cardHolder)
                .navigationDestination(for: UUID.self) { id in
                    DetailView(cardID: id)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isNewCardPresented = true
                        } label: {
                            Image(systemName: "plus")
                        }
                        .accessibilityIdentifier("BizScan.Home.Add")
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isSearchPresented = true
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                        .accessibilityIdentifier("BizScan.Home.Search")
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    scanButton
                }
                .onAppear { loadIfNeeded() }
                .fullScreenCover(isPresented: $isScannerPresented, onDismiss: { viewModel?.reload() }) {
                    ScannerView()
                }
                .sheet(isPresented: $isSearchPresented, onDismiss: { viewModel?.reload() }) {
                    SearchView()
                }
                .sheet(isPresented: $isNewCardPresented, onDismiss: { viewModel?.reload() }) {
                    NewCardView()
                }
                .sheet(isPresented: $isGroupManagementPresented, onDismiss: { viewModel?.reload() }) {
                    GroupManagementView(
                        selectedGroup: Binding(
                            get: { viewModel?.selectedGroup },
                            set: { viewModel?.selectedGroup = $0 }
                        )
                    )
                }
                .confirmationDialog(
                    AppCopy.moveToGroup,
                    isPresented: Binding(
                        get: { movingCard != nil },
                        set: { if !$0 { movingCard = nil } }
                    ),
                    titleVisibility: .visible
                ) {
                    Button(AppCopy.ungrouped) { moveToGroup(nil) }
                    ForEach(viewModel?.groups ?? [], id: \.self) { group in
                        Button(group) { moveToGroup(group) }
                    }
                    Button(AppCopy.cancel, role: .cancel) { movingCard = nil }
                }
                .confirmationDialog(
                    AppCopy.deleteConfirmTitle,
                    isPresented: Binding(
                        get: { pendingDelete != nil },
                        set: { if !$0 { pendingDelete = nil } }
                    ),
                    titleVisibility: .visible
                ) {
                    Button(AppCopy.delete, role: .destructive) {
                        if let card = pendingDelete {
                            viewModel?.delete(card)
                        }
                        pendingDelete = nil
                    }
                    Button(AppCopy.cancel, role: .cancel) {
                        pendingDelete = nil
                    }
                } message: {
                    Text(AppCopy.deleteConfirmMessage)
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
    }

    @ViewBuilder
    private var content: some View {
        if let viewModel {
            if viewModel.isEmpty {
                EmptyStateView {
                    isScannerPresented = true
                }
            } else {
                VStack(spacing: 0) {
                    groupBar(viewModel)
                    List {
                        ForEach(viewModel.visibleCards) { card in
                            NavigationLink(value: card.id) {
                                CardRowView(
                                    card: card,
                                    thumbnail: viewModel.thumbnail(for: card)
                                )
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    pendingDelete = card
                                } label: {
                                    Label(AppCopy.delete, systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button {
                                    movingCard = card
                                } label: {
                                    Label(AppCopy.groupTitle, systemImage: "folder")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .accessibilityIdentifier("BizScan.Home.CardList")
                }
            }
        } else {
            ProgressView()
        }
    }

    private func groupBar(_ viewModel: HomeViewModel) -> some View {
        HStack(spacing: 8) {
            Menu {
                Button {
                    viewModel.selectGroup(nil)
                } label: {
                    if viewModel.selectedGroup == nil {
                        Label("\(AppCopy.allGroups) \(viewModel.count(in: nil))", systemImage: "checkmark")
                    } else {
                        Text("\(AppCopy.allGroups) \(viewModel.count(in: nil))")
                    }
                }
                ForEach(viewModel.groups, id: \.self) { group in
                    Button {
                        viewModel.selectGroup(group)
                    } label: {
                        if viewModel.selectedGroup?.caseInsensitiveCompare(group) == .orderedSame {
                            Label("\(group) \(viewModel.count(in: group))", systemImage: "checkmark")
                        } else {
                            Text("\(group) \(viewModel.count(in: group))")
                        }
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Text(viewModel.currentGroupTitle)
                        .font(.subheadline.weight(.semibold))
                    Text("\(viewModel.visibleCards.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Image(systemName: "chevron.down")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .foregroundStyle(.primary)
            }
            .accessibilityIdentifier("BizScan.Home.GroupMenu")

            Spacer(minLength: 0)

            Button {
                isGroupManagementPresented = true
            } label: {
                Label(AppCopy.groupManagement, systemImage: "folder")
                    .font(.footnote)
            }
            .accessibilityIdentifier("BizScan.Home.GroupManage")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private func moveToGroup(_ group: String?) {
        guard let card = movingCard else { return }
        viewModel?.move(card, to: group)
        movingCard = nil
    }

    private var scanButton: some View {
        Button {
            isScannerPresented = true
        } label: {
            Image(systemName: "camera.viewfinder")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(Circle().fill(Color.accentColor))
                .shadow(radius: 6, y: 2)
        }
        .padding(20)
        .accessibilityIdentifier("BizScan.Home.Scan")
    }

    private func loadIfNeeded() {
        if viewModel == nil {
            viewModel = HomeViewModel(
                repository: environment.repository,
                imageStore: environment.imageStore
            )
        }
        viewModel?.reload()
    }
}

#Preview {
    Text("HomeView 需要 AppEnvironment，见 BizScanApp")
}
