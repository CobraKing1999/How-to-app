//
//  HowToApp.swift
//  How To
//
//  Main app entry point
//

import SwiftUI

@main
struct HowToApp: App {
    @StateObject private var themeService = ThemeService()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                RootTabView()
                    .environmentObject(themeService)
                    .preferredColorScheme(themeService.colorScheme)
            } else {
                OnboardingView()
                    .environmentObject(themeService)
                    .preferredColorScheme(themeService.colorScheme)
            }
        }
    }
}

//test comment
