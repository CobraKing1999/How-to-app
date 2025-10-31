//
//  HowToItem.swift
//  How To
//
//  Model representing a how-to guide result
//

import Foundation

struct HowToItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let summary: String
    let steps: [String]            // In-app steps
    let sourceURL: URL?            // Optional external link
    
    init(title: String, summary: String, steps: [String], sourceURL: URL?) {
        self.title = title
        self.summary = summary
        self.steps = steps
        self.sourceURL = sourceURL
    }
}

struct SearchHistoryItem: Identifiable, Codable, Equatable {
    let id: UUID
    let query: String
    let timestamp: Date
    
    init(id: UUID = UUID(), query: String, timestamp: Date = Date()) {
        self.id = id
        self.query = query
        self.timestamp = timestamp
    }
}

