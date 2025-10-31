//
//  RootTabView.swift
//  How To
//
//  Root tab navigation container
//

import SwiftUI

struct RootTabView: View {
    @StateObject private var historyViewModel = HistoryViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FeaturedView()
                .tabItem {
                    Label("Featured", systemImage: "star")
                }
                .accessibilityLabel("Featured tab")
                .tag(0)
            
            SearchView(historyViewModel: historyViewModel)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .accessibilityLabel("Search tab")
                .tag(1)
            
            HistoryView(historyViewModel: historyViewModel)
                .tabItem {
                    Label("History", systemImage: "clock")
                }
                .accessibilityLabel("History tab")
                .tag(2)
            
            SettingsView(historyViewModel: historyViewModel)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .accessibilityLabel("Settings tab")
                .tag(3)
        }
    }
}

#Preview {
    RootTabView()
}

