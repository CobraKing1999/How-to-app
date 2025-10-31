//
//  OnboardingView.swift
//  How To
//
//  Main onboarding flow view
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @EnvironmentObject var themeService: ThemeService
    @State private var currentPage = 0
    @State private var showThemeSelector = false
    @Environment(\.dismiss) private var dismiss
    
    let pages = OnboardingPage.pages
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    pages[currentPage].accentColor.opacity(0.1),
                    pages[currentPage].accentColor.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.5), value: currentPage)
            
            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            completeOnboarding()
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding()
                    }
                }
                
                // Content
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                        OnboardingPageView(
                            page: page,
                            pageIndex: index,
                            totalPages: pages.count,
                            showThemeSelector: $showThemeSelector
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                // No page indicator needed for single page
                
                // Action button - Get Started
                VStack(spacing: 12) {
                    Button {
                        completeOnboarding()
                    } label: {
                        Text("Get Started")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(pages[currentPage].accentColor)
                            .cornerRadius(16)
                    }
                    .shadow(color: pages[currentPage].accentColor.opacity(0.3), radius: 10, y: 5)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 34)
            }
        }
    }
    
    private func completeOnboarding() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            hasCompletedOnboarding = true
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(ThemeService())
}

