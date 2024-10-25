//
//  ChangePasscode.swift
//  Authentication
//
//  Created by Mit Patel on 10/10/24.
//

import SwiftUI


struct ChangePasscode: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var lengths = ["4-Digits", "6-Digits"]
    @State private var passcodeLength = 4
    @State private var currentPasscode: String = ""
    @State private var newPasscode: String = ""
    @State private var confirmNewPasscode: String = ""
    @State private var errorMessage: String?
    @State private var step: Int = 1 // 1: Verify Current, 2: Set New Passcode
    @State private var isShowPassword = false
    @StateObject private var passcodeManager = PasscodeManager.shared
    

    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                if step == 2 {
                    Text("Enter Current Passcode")
                        .font(.customfont(.arial, fontSize: 24))
                        .padding(.bottom)
                    
                    LineSecureField(title: "Current Passcode", placeholder: "Enter your current passcode", txt: $currentPasscode, isShowPassword: $isShowPassword)
                        .keyboardType(.numberPad)
                    
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                    }
                    
                    FilledButton(title: "Next"){
                        if PasscodeManager.shared.verifyPasscode(currentPasscode) {
                            step = 2
                            errorMessage = nil
                        } else {
                            errorMessage = "Incorrect Passcode."
                            currentPasscode = ""
                        }
                    }
                } else if step == 1 {
                    Text("Set New Passcode")
                        .font(.title)
                    
                    Picker("", selection: $passcodeLength) {
                        Text("4-Digits").tag(4)
                        Text("6-Digits").tag(6)
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom)
                    
                    LineSecureField(title: "New Passcode", placeholder: "Enter New Passcode", txt: $newPasscode, isShowPassword: $isShowPassword)
                        .keyboardType(.numberPad)
                    
                    LineSecureField(title: "Confirm New Passcode", placeholder: "Enter Confirm Passcode", txt: $confirmNewPasscode, isShowPassword: $isShowPassword)
                        .keyboardType(.numberPad)
                    
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                    }
                    
                    FilledButton(title: "Change Passcode"){
                        if newPasscode.count == passcodeLength {
                            if newPasscode == confirmNewPasscode {
                                dismiss()
                                passcodeManager.changePasscode(passcode: newPasscode)
                            } else if newPasscode.count == 0 || confirmNewPasscode.count == 0{
                                errorMessage = "All fields are required."
                            } else {
                                errorMessage = "Passcodes do not match."
                            }
                        } else {
                            errorMessage = "Passcode must be \(passcodeLength) digits."
                        }
                    }
                }
                
                Spacer()
            }
            .frame(width: .screenWidth * 0.9)
            .navigationBarItems(trailing: Button("Close") {
                dismiss()
            })
            .padding()
        }
    }
}
struct ChangePasscode_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasscode()
    }
}
