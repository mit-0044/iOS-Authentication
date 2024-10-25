//
//  Passcode.swift
//  Authentication
//
//  Created by Mit Patel on 10/10/24.
//

import SwiftUI

struct Passcode: View {
    
    @StateObject private var passcodeManager = PasscodeManager.shared
    @Environment(\.dismiss) var dismiss
    @State private var showingCreatePasscode = false
    @State private var showingChangePasscode = false
    @State private var showingDisablePasscode = false
    @State private var showingBiometricToggle = false
    @State private var isBiometricEnabled = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Passcode")) {
                    if PasscodeManager.shared.isPasscodeEnabled {
                        Button("Change Passcode") {
                            showingChangePasscode = true
                        }
                        Button("Disable Passcode") {
                            showingDisablePasscode = true
                        }
                        .foregroundColor(.colorDanger)
                    } else {
                        Button("Set Passcode") {
                            showingCreatePasscode = true
                        }
                    }
                }
                
                if PasscodeManager.shared.isPasscodeEnabled {
                    Section(header: Text("Biometrics")) {
                        Toggle("Use Face ID / Touch ID", isOn: $isBiometricEnabled)
                            .onChange(of: isBiometricEnabled, perform: { value in
                                if value == true {
                                    if BiometricManager.shared.biometricEnabled && value == true {
                                        return
                                    }
                                    BiometricManager.shared.authenticateWithBiometrics { success, error in
                                        if success {
                                            BiometricManager.shared.biometricEnabled = true
                                        } else {
                                            BiometricManager.shared.biometricEnabled = false
                                            isBiometricEnabled = false
                                        }
                                    }
                                } else if value == false {
                                    BiometricManager.shared.biometricEnabled = false
                                }
                            })
                    }
                }
            }
            .onAppear{
                if BiometricManager.shared.biometricEnabled == true {
                    isBiometricEnabled = true
                } else if BiometricManager.shared.biometricEnabled == false {
                    isBiometricEnabled = false
                }
            }
            .navigationTitle("Passcode Setting")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingCreatePasscode) {
                CreatePasscode()
                    .presentationDetents([.height(400)])
                    .presentationCornerRadius(25)
            }
            .sheet(isPresented: $showingChangePasscode) {
                ChangePasscode()
                    .presentationDetents([.height(400)])
                    .presentationCornerRadius(25)
            }
            .alert(isPresented: $passcodeManager.showSuccess) {
                Alert(
                    title: Text(Utilities.AppName),
                    message: Text(passcodeManager.successMessage),
                    dismissButton: .default(Text("Okay"))
                )
            }
            .alert(isPresented: $showingDisablePasscode) {
                Alert(
                    title: Text(Utilities.AppName),
                    message: Text("Are you sure you want to disable your passcode?"),
                    primaryButton: .destructive(Text("Disable")) {
                        PasscodeManager.shared.disablePasscode()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct Passcode_Preview: PreviewProvider {
    static var previews: some View {
        Passcode()
    }
}
