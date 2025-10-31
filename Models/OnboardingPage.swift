//
//  OnboardingPage.swift
//  How To
//
//  Model representing an onboarding page
//

import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
    let systemImage: String?
    let accentColor: Color
    
    init(title: String, subtitle: String, imageName: String = "", systemImage: String? = nil, accentColor: Color = .blue) {
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
        self.systemImage = systemImage
        self.accentColor = accentColor
    }
}

extension OnboardingPage {
    static let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to How To",
            subtitle: "Choose your preferred theme to get started",
            systemImage: "paintbrush.fill",
            accentColor: .purple
        )
    ]
}

