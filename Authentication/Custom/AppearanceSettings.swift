//
//  AppearanceSettings.swift
//  Authentication
//
//  Created by Mit Patel on 11/10/24.
//

import SwiftUI

class AppearanceSettings: ObservableObject {
    enum AppearanceType: String, CaseIterable {
        case system
        case light
        case dark
    }

    @Published var appearanceType: AppearanceType = .system {
        didSet {
            updateAppearance()
            saveAppearance()
        }
    }
    
    init() {
        loadAppearance() // Load appearance from UserDefaults when app starts
        updateAppearance() // Apply appearance immediately when app starts
    }

    // Save the selected appearance to UserDefaults
    func saveAppearance() {
        UserDefaults.standard.set(appearanceType.rawValue, forKey: "appearanceType")
    }

    // Load the appearance from UserDefaults
    func loadAppearance() {
        if let savedAppearance = UserDefaults.standard.string(forKey: "appearanceType"),
           let appearance = AppearanceType(rawValue: savedAppearance) {
            self.appearanceType = appearance
        }
    }

    // Apply the appearance to the app
    func updateAppearance() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            switch appearanceType {
            case .light:
                windowScene.windows.first?.overrideUserInterfaceStyle = .light
            case .dark:
                windowScene.windows.first?.overrideUserInterfaceStyle = .dark
            case .system:
                windowScene.windows.first?.overrideUserInterfaceStyle = .unspecified
            }
        }
    }
}
