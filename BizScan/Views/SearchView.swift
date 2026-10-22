import SwiftUI

struct SearchView: View {
    @Environment(AppEnvironment.self) private var environment
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: SearchViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    searchContent(viewModel)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle(AppCopy.search)
            .navigationDestination(for: UUID.self) { id in
                DetailView(cardID: id)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(AppCopy.cancel) { dismiss() }
                }
            }
        }
        .task {
            if viewModel == nil {
                viewModel = SearchViewModel(
                    repository: environment.repository,
                    imageStore: environment.imageStore
                )
            }
            viewModel?.load()
        }
    }

    private func searchContent(_ viewModel: SearchViewModel) -> some View {
        @Bindable var viewModel = viewModel

        return List {
            ForEach(viewModel.results) { card in
                NavigationLink(value: card.id) {
                    CardRowView(card: card, thumbnail: viewModel.thumbnail(for: card))
                }
            }
        }
        .listStyle(.plain)
        .overlay {
            if viewModel.results.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text(AppCopy.searchEmpty)
                        .font(.headline)
                    Text(AppCopy.searchPlaceholder)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
            }
        }
        .searchable(text: $viewModel.keyword, prompt: Text(AppCopy.searchPlaceholder))
    }
}
