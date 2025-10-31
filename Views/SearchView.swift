//
//  SearchView.swift
//  How To
//
//  Search tab view
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel: SearchViewModel
    @FocusState private var isSearchFieldFocused: Bool
    
    init(historyViewModel: HistoryViewModel) {
        _viewModel = StateObject(wrappedValue: SearchViewModel(historyViewModel: historyViewModel))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search input area
                HStack(spacing: 12) {
                    TextField("What do you want to learn?", text: $viewModel.searchQuery)
                        .textFieldStyle(.roundedBorder)
                        .focused($isSearchFieldFocused)
                        .submitLabel(.search)
                        .onSubmit {
                            Task {
                                await viewModel.performSearch()
                            }
                        }
                        .accessibilityLabel("Search query")
                        .accessibilityHint("Enter what you want to learn about")
                    
                    Button {
                        Task {
                            await viewModel.performSearch()
                        }
                    } label: {
                        if viewModel.isSearching {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .frame(width: 20, height: 20)
                        } else {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.blue)
                        }
                    }
                    .disabled(viewModel.searchQuery.trimmingCharacters(in: .whitespaces).isEmpty || viewModel.isSearching)
                    .accessibilityLabel("Search button")
                    .accessibilityHint("Tap to search for guides")
                }
                .padding()
                .background(Color(.systemBackground))
                
                Divider()
                
                // Results area
                Group {
                    if !viewModel.hasSearched {
                        EmptyState(
                            icon: "magnifyingglass",
                            title: "Search for Guides",
                            message: "Enter a topic to find helpful how-to guides"
                        )
                    } else if viewModel.isSearching {
                        ProgressView("Searching...")
                            .accessibilityLabel("Searching for guides")
                    } else if let errorMessage = viewModel.errorMessage {
                        EmptyState(
                            icon: "exclamationmark.triangle",
                            title: "Search Failed",
                            message: errorMessage
                        )
                    } else if viewModel.results.isEmpty {
                        EmptyState(
                            icon: "magnifyingglass",
                            title: "No Results",
                            message: "Try a different search term"
                        )
                    } else {
                        List(viewModel.results) { item in
                            NavigationLink(value: item) {
                                HowToRow(item: item)
                            }
                        }
                        .listStyle(.insetGrouped)
                        .navigationDestination(for: HowToItem.self) { item in
                            HowToDetailView(item: item)
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if viewModel.hasSearched {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Clear") {
                            viewModel.clearSearch()
                            isSearchFieldFocused = true
                        }
                        .accessibilityLabel("Clear search")
                        .accessibilityHint("Clears the search results and query")
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView(historyViewModel: HistoryViewModel())
}

