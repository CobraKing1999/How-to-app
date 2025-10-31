//
//  ThemeService.swift
//  How To
//
//  Service for managing app theme/appearance
//

import SwiftUI
import Combine

enum ThemeMode: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
}

@MainActor
class ThemeService: ObservableObject {
    @Published var themeMode: ThemeMode {
        didSet {
            UserDefaults.standard.set(themeMode.rawValue, forKey: themeModeKey)
        }
    }
    
    private let themeModeKey = "themeMode"
    
    var colorScheme: ColorScheme? {
        switch themeMode {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    init() {
        if let savedMode = UserDefaults.standard.string(forKey: themeModeKey),
           let mode = ThemeMode(rawValue: savedMode) {
            self.themeMode = mode
        } else {
            self.themeMode = .system
        }
    }
}

