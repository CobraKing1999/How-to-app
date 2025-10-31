//
//  SettingsView.swift
//  How To
//
//  Settings tab view
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @ObservedObject var historyViewModel: HistoryViewModel
    @EnvironmentObject var themeService: ThemeService
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showOnboarding = false
    
    var body: some View {
        NavigationStack {
            Form {
                // Appearance Section
                Section {
                    Picker("Appearance", selection: $themeService.themeMode) {
                        Text("System").tag(ThemeMode.system)
                        Text("Light").tag(ThemeMode.light)
                        Text("Dark").tag(ThemeMode.dark)
                    }
                    .accessibilityLabel("Appearance mode")
                    .accessibilityHint("Choose between system, light, or dark mode")
                } header: {
                    Text("Appearance")
                } footer: {
                    Text("Choose your preferred color scheme")
                }
                
                // History Section
                Section {
                    Button(role: .destructive) {
                        viewModel.showingClearHistoryAlert = true
                    } label: {
                        Label("Clear History", systemImage: "trash")
                    }
                    .disabled(historyViewModel.historyItems.isEmpty)
                    .accessibilityLabel("Clear history")
                    .accessibilityHint("Removes all search history items")
                } header: {
                    Text("History")
                } footer: {
                    Text("Delete all search history permanently")
                }
                
                // About Section
                Section {
                    Button {
                        viewModel.showingAbout = true
                    } label: {
                        Label("About", systemImage: "info.circle")
                    }
                    .accessibilityLabel("About")
                    .accessibilityHint("View app information")
                    
                    Button {
                        showOnboarding = true
                    } label: {
                        Label("View Onboarding", systemImage: "rectangle.stack.fill")
                    }
                    .accessibilityLabel("View onboarding")
                    .accessibilityHint("Shows the app introduction screens again")
                    
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("\(viewModel.appVersion) (\(viewModel.buildNumber))")
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Version \(viewModel.appVersion) build \(viewModel.buildNumber)")
                } header: {
                    Text("App Info")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .alert("Clear History", isPresented: $viewModel.showingClearHistoryAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    historyViewModel.clearHistory()
                }
            } message: {
                Text("Are you sure you want to delete all search history? This action cannot be undone.")
            }
            .sheet(isPresented: $viewModel.showingAbout) {
                AboutSheet()
            }
            .fullScreenCover(isPresented: $showOnboarding) {
                OnboardingView()
                    .environmentObject(themeService)
            }
        }
    }
}

struct AboutSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.blue)
                        .padding(.top, 40)
                        .accessibilityHidden(true)
                    
                    Text("How To")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Your guide to learning anything")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Features:")
                            .font(.headline)
                        
                        FeatureRow(icon: "star.fill", text: "Curated featured guides")
                        FeatureRow(icon: "magnifyingglass", text: "Powerful search")
                        FeatureRow(icon: "clock.fill", text: "Search history")
                        FeatureRow(icon: "moon.fill", text: "Dark mode support")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    
                    Text("Built with SwiftUI")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 20)
                }
                .padding()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.blue)
                .frame(width: 24)
                .accessibilityHidden(true)
            Text(text)
                .font(.subheadline)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    SettingsView(historyViewModel: HistoryViewModel())
        .environmentObject(ThemeService())
}

