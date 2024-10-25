//
//  PasscodeManager.swift
//  Authentication
//
//  Created by Mit Patel on 10/10/24.
//

import SwiftUI
import Foundation
import LocalAuthentication

class PasscodeManager: ObservableObject {
    static let shared = PasscodeManager()
    
    @Published var showSuccess: Bool = false
    @Published var successMessage: String = ""
    
    @Published var isPasscodeEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isPasscodeEnabled, forKey: "isPasscodeEnabled")
        }
    }
    
    @Published var passcode: String? {
        didSet {
            UserDefaults.standard.set(passcode, forKey: "userPasscode")
        }
    }
    
    private init() {
        self.isPasscodeEnabled = UserDefaults.standard.bool(forKey: "isPasscodeEnabled")
        self.passcode = UserDefaults.standard.string(forKey: "userPasscode")
    }
    
    // Verify the entered passcode
    func verifyPasscode(_ input: String) -> Bool {
        return input == passcode
    }
    
    // Remove the passcode
    func setPasscode(passcode: String) {
        self.passcode = passcode
        self.isPasscodeEnabled = true
        self.showSuccess = true
        self.successMessage = "Passcode has been set."
    }
    
    func changePasscode(passcode: String) {
        self.passcode = passcode
        self.showSuccess = true
        self.successMessage = "Passcode has been changed."
    }
    
    func disablePasscode() {
        self.passcode = nil
        self.isPasscodeEnabled = false
        BiometricManager.shared.biometricEnabled = false
        self.showSuccess = true
        self.successMessage = "Passcode has been disabled."
    }
}
