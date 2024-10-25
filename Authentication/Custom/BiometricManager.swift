//
//  BiometricManager.swift
//  Authentication
//
//  Created by Mit Patel on 10/10/24.
//

import SwiftUI
import Foundation
import LocalAuthentication

class BiometricManager: ObservableObject {
    
    static let shared = BiometricManager()
    static let isBiometricEnabled: Bool = Utilities.UDValueBool(key: "biometricEnabled")
    
    @Published var biometricEnabled: Bool {
        didSet {
            Utilities.UDSET(data: biometricEnabled, key: "biometricEnabled")
        }
    }
    
    private init() {
        self.biometricEnabled = Utilities.UDValueBool(key: "biometricEnabled")
    }
    
    func authenticateWithBiometrics(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock using Face ID or Touch ID") { success, authError in
                DispatchQueue.main.async {
                    completion(success, authError)
                }
            }
        } else {
            completion(false, error)
        }
    }
}
