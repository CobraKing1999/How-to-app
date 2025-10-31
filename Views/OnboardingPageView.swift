//
//  OnboardingPageView.swift
//  How To
//
//  Individual onboarding page view
//

import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPage
    let pageIndex: Int
    let totalPages: Int
    @Binding var showThemeSelector: Bool
    @EnvironmentObject var themeService: ThemeService
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon/Image
            if let systemImage = page.systemImage {
                ZStack {
                    // Background circle
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    page.accentColor.opacity(0.3),
                                    page.accentColor.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 200, height: 200)
                        .scaleEffect(isAnimating ? 1.0 : 0.8)
                        .opacity(isAnimating ? 1 : 0)
                    
                    // Icon
                    Image(systemName: systemImage)
                        .font(.system(size: 80, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [page.accentColor, page.accentColor.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(from: 0.5, to: 1.0, duration: 0.6)
                        .onboardingAppearance(delay: 0.1)
                }
                .frame(height: 220)
            }
            
            Spacer()
            
            // Text content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .onboardingAppearance(delay: 0.2)
                
                Text(page.subtitle)
                    .font(.system(size: 17, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
                    .onboardingAppearance(delay: 0.3)
            }
            
            Spacer()
            
            // Always show theme picker on this single page
            themePickerView
            
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                isAnimating = true
                showThemeSelector = true
            }
        }
    }
    
    // MARK: - Search Examples View
    private var searchExamplesView: some View {
        VStack(spacing: 12) {
            ForEach(["How to tie a tie", "Fix a flat tire", "Cook perfect pasta"], id: \.self) { example in
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    Text(example)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal, 32)
        .transition(.opacity.combined(with: .scale))
    }
    
    // MARK: - Theme Picker View
    private var themePickerView: some View {
        VStack(spacing: 16) {
            Text("Choose Your Theme")
                .font(.system(size: 20, weight: .semibold))
                .padding(.bottom, 8)
            
            HStack(spacing: 16) {
                ForEach([ThemeMode.light, ThemeMode.dark, ThemeMode.system], id: \.self) { mode in
                    ThemeOptionButton(
                        mode: mode,
                        isSelected: themeService.themeMode == mode
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            themeService.themeMode = mode
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.1))
        )
        .padding(.horizontal, 24)
        .transition(.opacity.combined(with: .scale))
    }
}

// MARK: - Theme Option Button
struct ThemeOptionButton: View {
    let mode: ThemeMode
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(backgroundColor)
                        .frame(width: 80, height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(
                                    isSelected ? Color.purple : Color.clear,
                                    lineWidth: 3
                                )
                        )
                    
                    Image(systemName: iconName)
                        .font(.system(size: 30))
                        .foregroundColor(iconColor)
                }
                
                Text(mode.rawValue)
                    .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .purple : .secondary)
            }
        }
        .buttonStyle(.plain)
    }
    
    private var iconName: String {
        switch mode {
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        case .system: return "circle.lefthalf.filled"
        }
    }
    
    private var iconColor: Color {
        switch mode {
        case .light: return .orange
        case .dark: return .indigo
        case .system: return .blue
        }
    }
    
    private var backgroundColor: Color {
        switch mode {
        case .light: return Color.white
        case .dark: return Color.black.opacity(0.8)
        case .system: return Color.gray.opacity(0.2)
        }
    }
}

#Preview {
    OnboardingPageView(
        page: OnboardingPage.pages[0],
        pageIndex: 0,
        totalPages: 5,
        showThemeSelector: .constant(false)
    )
    .environmentObject(ThemeService())
}

