//
//  CreatePasscode.swift
//  Authentication
//
//  Created by Mit Patel on 10/10/24.
//

import SwiftUI

struct CreatePasscode: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var passcodeLength = 4
    @State private var passcode: String = ""
    @State private var confirmPasscode: String = ""
    @State private var errorMessage: String?
    @State private var isShowPassword: Bool = false
    @StateObject private var passcodeManager = PasscodeManager.shared
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                Text("Create Passcode")
                    .font(.customfont(.arial, fontSize: 24))
                    .padding(.bottom)
                
                Picker("What is your favorite color?", selection: $passcodeLength) {
                    Text("4-Digits").tag(4)
                    Text("6-Digits").tag(6)
                }
                .pickerStyle(.segmented)
                .padding(.bottom)
                
                LineSecureField(title: "Passcode", placeholder: "Enter your passcode", txt: $passcode, isShowPassword: $isShowPassword)
                    .keyboardType(.numberPad)
                
                LineSecureField(title: "Confirm Passcode", placeholder: "Enter confirm passcode", txt: $confirmPasscode, isShowPassword: $isShowPassword)
                    .keyboardType(.numberPad)
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
                
                FilledButton(title: "Set Passcode"){
                    if passcode.count == passcodeLength {
                        if passcode == confirmPasscode {
                            dismiss()
                            passcodeManager.setPasscode(passcode: passcode)
                        } else if passcode.count == 0 || confirmPasscode.count == 0{
                            errorMessage = "All fields are required."
                        } else {
                            errorMessage = "Passcodes do not match."
                        }
                    } else {
                        errorMessage = "Passcode must be \(passcodeLength) digits."
                    }
                }
                Spacer()
            }
            .navigationBarItems(trailing: Button("Close") {
                dismiss()
            })
            .frame(width: .screenWidth * 0.9)
        }
    }

}

struct CreatePasscode_Previews: PreviewProvider {
    static var previews: some View {
        CreatePasscode()
    }
}
