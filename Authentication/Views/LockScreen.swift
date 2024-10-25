//
//  LockScreen.swift
//  Authentication
//
//  Created by Mit Patel on 10/10/24.
//

import SwiftUI
import LocalAuthentication

struct LockScreen: View {
    @Binding var isAuthenticated: Bool
    @State private var inputPasscode: String = ""
    @State private var showBiometricOption = false
    @State private var biometricError: String?
    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 10) {
                    Image("otp")
                        .resizable()
                        .scaledToFit()
                        .frame(width: .screenWidth * 0.75)
                        .padding(.top, .topInsets)
                        .padding(.bottom, .bottomInsets)
                    
                    SecureField("Enter your passcode", text: $inputPasscode)
                        .keyboardType(.numberPad)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.gray.opacity(0.25), lineWidth: 1)
                        )
                    
                    if let error = biometricError {
                        Text(error)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    FilledButton(title: "Unlock"){
                        if PasscodeManager.shared.verifyPasscode(inputPasscode) {
                            isAuthenticated = true
                        } else {
                            if inputPasscode.count == 0 {
                                biometricError = "Please enter your passcode."
                            }else {
                                biometricError = "Incorrect passcode."
                            }
                        }
                    }
                    
                    if BiometricManager.shared.biometricEnabled == true {
                        
                        Text("OR")
                            .font(.customfont(.bold, fontSize: 22))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.black.opacity(0.25))
                            .padding(.bottom, 15)
                    
                        Button {
                            BiometricManager.shared.authenticateWithBiometrics { success, error in
                                if success {
                                    isAuthenticated = true
                                } else {
                                    biometricError = error?.localizedDescription
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: biometricType() == .faceID ? "faceid" : "touchid")
                                Text("Use \(biometricType() == .faceID ? "Face ID" : "Touch ID")")
                            }
                            .font(.customfont(.bold, fontSize: 22))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .frame( minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60 )
                            .background(.colorSecondary)
                            .cornerRadius(20)
                        }
                        .padding(.bottom, 15)
                    }
                    
                    Spacer()
                }
            }
            .frame(width: .screenWidth * 0.9)
        }
    }
    func biometricType() -> LABiometryType {
        let context = LAContext()
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return context.biometryType
    }
}

struct LockScreen_Preview: PreviewProvider {
    @State static var isAuthenticated = true
    static var previews: some View {
        LockScreen(isAuthenticated: $isAuthenticated)
    }
}
