//
//  ContentView.swift
//  Authentication
//
//  Created by Mit Patel on 14/10/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @StateObject private var passcodeManager = PasscodeManager.shared
    @StateObject private var networkMonitor = NetworkMonitor()
    @State private var showAlert = false
    @State private var isAuthenticated = false

    var body: some View {
        NavigationView {
            VStack{
                if passcodeManager.isPasscodeEnabled {
                    if isAuthenticated {
                        if Utilities.UDValueBool(key: "isLoggedIn") {
                            MainTabView()
                        }else{
                            Login()
                        }
                    } else {
                        LockScreen(isAuthenticated: $isAuthenticated)
                    }
                } else {
                    if Utilities.UDValueBool(key: "isLoggedIn") {
                        MainTabView()
                    }else{
                        Login()
                    }
                }
            }
            .onChange(of: networkMonitor.isConnected) { isConnected in
                if !isConnected {
                    showAlert = true
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Connection Lost"),
                    message: Text("Please check your internet connection."),
                    primaryButton: .default(Text("Retry"), action: {
                        retryConnection()
                    }),
                    secondaryButton: .default(Text("Open Settings"), action: {
                        openAppSettings()
                    })
                )
            }
        }
    }
    func retryConnection() {
        self.showAlert = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.networkMonitor.isConnected = false
            if networkMonitor.isConnected == false {
                self.showAlert = true
            }
        }
    }
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppearanceSettings())
    }
}
