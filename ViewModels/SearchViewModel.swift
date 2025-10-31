//
//  SearchViewModel.swift
//  How To
//
//  View model for the Search tab
//

import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var results: [HowToItem] = []
    @Published var isSearching = false
    @Published var errorMessage: String?
    @Published var hasSearched = false
    
    private let service = HowToService.shared
    private let historyViewModel: HistoryViewModel
    
    init(historyViewModel: HistoryViewModel) {
        self.historyViewModel = historyViewModel
    }
    
    func performSearch() async {
        guard !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        isSearching = true
        errorMessage = nil
        hasSearched = true
        
        do {
            results = try await service.search(query: searchQuery)
            
            // Save to history
            historyViewModel.addSearch(query: searchQuery)
        } catch {
            errorMessage = "Search failed: \(error.localizedDescription)"
            results = []
        }
        
        isSearching = false
    }
    
    func clearSearch() {
        searchQuery = ""
        results = []
        hasSearched = false
        errorMessage = nil
    }
}

