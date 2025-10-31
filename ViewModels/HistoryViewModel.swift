//
//  HistoryViewModel.swift
//  How To
//
//  View model for the History tab
//

import Foundation
import Combine
import SwiftUI

@MainActor
class HistoryViewModel: ObservableObject {
    @Published var historyItems: [SearchHistoryItem] = []
    
    private let maxHistoryItems = 20
    private let historyKey = "searchHistory"
    
    init() {
        loadHistory()
    }
    
    func addSearch(query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespaces)
        guard !trimmedQuery.isEmpty else { return }
        
        // Remove duplicate if exists
        historyItems.removeAll { $0.query.lowercased() == trimmedQuery.lowercased() }
        
        // Add new item at the beginning
        let newItem = SearchHistoryItem(query: trimmedQuery)
        historyItems.insert(newItem, at: 0)
        
        // Trim to max items
        if historyItems.count > maxHistoryItems {
            historyItems = Array(historyItems.prefix(maxHistoryItems))
        }
        
        saveHistory()
    }
    
    func deleteItem(at offsets: IndexSet) {
        historyItems.remove(atOffsets: offsets)
        saveHistory()
    }
    
    func clearHistory() {
        historyItems.removeAll()
        saveHistory()
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(historyItems) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }
    }
    
    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: historyKey),
           let decoded = try? JSONDecoder().decode([SearchHistoryItem].self, from: data) {
            historyItems = decoded
        }
    }
}

