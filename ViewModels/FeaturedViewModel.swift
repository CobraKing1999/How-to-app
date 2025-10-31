//
//  FeaturedViewModel.swift
//  How To
//
//  View model for the Featured tab
//

import Foundation
import Combine

@MainActor
class FeaturedViewModel: ObservableObject {
    @Published var items: [HowToItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = HowToService.shared
    
    func loadFeatured() async {
        isLoading = true
        errorMessage = nil
        
        do {
            items = try await service.getFeaturedGuides()
        } catch {
            errorMessage = "Failed to load featured guides: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

