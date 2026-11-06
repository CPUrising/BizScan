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
            ZStack(alignment: .bottom) {
                Theme.page.ignoresSafeArea()

                VStack(spacing: 0) {
                    header
                    searchField
                    if let viewModel {
                        groupBar(viewModel)
                    }
                    Rectangle()
                        .fill(Theme.dividerWeak)
                        .frame(height: 1)
                    content
                }

                scanButton
            }
            .navigationDestination(for: UUID.self) { id in
                DetailView(cardID: id)
            }
            .toolbar(.hidden, for: .navigationBar)
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

    private var header: some View {
        HStack {
            Text(AppCopy.cardHolder)
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
                .accessibilityIdentifier("BizScan.Home.Title")
            Spacer()
            Button {
                isNewCardPresented = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Theme.textPrimary)
                    .frame(width: 40, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                            .fill(Theme.control)
                    )
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("BizScan.Home.Add")
        }
        .padding(.horizontal, Theme.Layout.screenPadding)
        .frame(height: Theme.Layout.headerHeight)
    }

    private var searchField: some View {
        Button {
            isSearchPresented = true
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Theme.textSecondary)
                Text(AppCopy.homeSearchPlaceholder)
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.textSecondary)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 14)
            .frame(height: Theme.Layout.searchHeight)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Theme.field)
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, Theme.Layout.screenPadding)
        .accessibilityIdentifier("BizScan.Home.Search")
    }

    @ViewBuilder
    private var content: some View {
        if let viewModel {
            if viewModel.cards.isEmpty {
                HomeEmptyState()
            } else if viewModel.visibleCards.isEmpty {
                Text(AppCopy.emptyGroup)
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.textSecondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                cardList(viewModel)
            }
        } else {
            ProgressView()
                .tint(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func cardList(_ viewModel: HomeViewModel) -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.sections) { section in
                    Text(section.title)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Theme.textTertiary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Theme.Layout.screenPadding)
                        .frame(height: Theme.Layout.dateHeaderHeight)

                    ForEach(Array(section.cards.enumerated()), id: \.element.id) { index, card in
                        CardListRow(
                            card: card,
                            thumbnail: viewModel.thumbnail(for: card),
                            onMove: { movingCard = card },
                            onDelete: { pendingDelete = card }
                        )
                        if index < section.cards.count - 1 {
                            Rectangle()
                                .fill(Theme.dividerWeak)
                                .frame(height: 1)
                                .padding(.horizontal, Theme.Layout.screenPadding)
                        }
                    }
                }

                Color.clear.frame(height: 120)
            }
        }
        .scrollIndicators(.hidden)
        .accessibilityIdentifier("BizScan.Home.CardList")
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
                HStack(spacing: 8) {
                    Text(viewModel.currentGroupTitle)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.textPrimary)
                    Text("\(viewModel.visibleCards.count)")
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.textTertiary)
                }
            }
            .accessibilityIdentifier("BizScan.Home.GroupMenu")

            Spacer(minLength: 0)

            Button {
                isGroupManagementPresented = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "folder")
                        .font(.system(size: 13, weight: .regular))
                    Text(AppCopy.groupManagement)
                        .font(.system(size: 13))
                }
                .foregroundStyle(Theme.textSecondary)
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("BizScan.Home.GroupManage")
        }
        .padding(.horizontal, Theme.Layout.screenPadding)
        .frame(height: Theme.Layout.groupBarHeight)
    }

    private var scanButton: some View {
        Button {
            isScannerPresented = true
        } label: {
            Image(systemName: "camera")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 68, height: 68)
                .background(Circle().fill(Theme.blue))
        }
        .buttonStyle(.plain)
        .padding(.bottom, 22)
        .accessibilityIdentifier("BizScan.Home.Scan")
    }

    private func moveToGroup(_ group: String?) {
        guard let card = movingCard else { return }
        viewModel?.move(card, to: group)
        movingCard = nil
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
