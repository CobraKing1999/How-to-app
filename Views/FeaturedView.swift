//
//  FeaturedView.swift
//  How To
//
//  Featured guides tab view
//

import SwiftUI

struct FeaturedView: View {
    @StateObject private var viewModel = FeaturedViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .accessibilityLabel("Loading featured guides")
                } else if let errorMessage = viewModel.errorMessage {
                    EmptyState(
                        icon: "exclamationmark.triangle",
                        title: "Error",
                        message: errorMessage
                    )
                } else if viewModel.items.isEmpty {
                    EmptyState(
                        icon: "star",
                        title: "No Featured Guides",
                        message: "Check back later for curated content"
                    )
                } else {
                    List(viewModel.items) { item in
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
            .navigationTitle("Featured")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.loadFeatured()
            }
            .refreshable {
                await viewModel.loadFeatured()
            }
        }
    }
}

#Preview {
    FeaturedView()
}

