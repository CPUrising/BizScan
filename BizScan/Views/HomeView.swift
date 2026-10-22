import SwiftUI
import UIKit
import BizScanCore

struct HomeView: View {
    @Environment(AppEnvironment.self) private var environment

    @State private var viewModel: HomeViewModel?
    @State private var isScannerPresented = false
    @State private var isSearchPresented = false
    @State private var pendingDelete: BusinessCard?

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
                    tagBar(viewModel)
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

    private func tagBar(_ viewModel: HomeViewModel) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                tagChip(AppCopy.allTags, selected: viewModel.selectedTag == nil) {
                    viewModel.selectedTag = nil
                }
                ForEach(viewModel.tags, id: \.self) { tag in
                    tagChip(tag, selected: viewModel.selectedTag == tag) {
                        viewModel.toggleTagFilter(tag)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }

    private func tagChip(_ title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.footnote.weight(selected ? .semibold : .regular))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(selected ? Color.accentColor.opacity(0.15) : Color(uiColor: .secondarySystemBackground))
                .foregroundStyle(selected ? Color.accentColor : Color.primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
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
