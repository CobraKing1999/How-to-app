//
//  SettingsViewModel.swift
//  How To
//
//  View model for the Settings tab
//

import Foundation
import Combine

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var showingAbout = false
    @Published var showingClearHistoryAlert = false
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
}

