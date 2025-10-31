//
//  HistoryView.swift
//  How To
//
//  Search history tab view
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var historyViewModel: HistoryViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if historyViewModel.historyItems.isEmpty {
                    EmptyState(
                        icon: "clock",
                        title: "No Search History",
                        message: "Your search history will appear here"
                    )
                } else {
                    List {
                        ForEach(historyViewModel.historyItems) { item in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.query)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                
                                Text(item.timestamp, style: .relative)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Searched for \(item.query), \(item.timestamp, style: .relative) ago")
                        }
                        .onDelete(perform: historyViewModel.deleteItem)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !historyViewModel.historyItems.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        EditButton()
                            .accessibilityLabel("Edit history")
                    }
                }
            }
        }
    }
}

#Preview {
    HistoryView(historyViewModel: HistoryViewModel())
}

