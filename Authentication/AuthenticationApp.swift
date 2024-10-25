//
//  AuthenticationApp.swift
//  Authentication
//
//  Created by Mit Patel on 14/10/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct AuthenticationApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var appearanceSettings = AppearanceSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appearanceSettings)
                .onAppear {
                    appearanceSettings.updateAppearance()
                }
        }
    }
}
