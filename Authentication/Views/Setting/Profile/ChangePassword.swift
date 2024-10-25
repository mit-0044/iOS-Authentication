//
//  ChangePassword.swift
//  Authentication
//
//  Created by Mit Patel on 02/09/24.
//

import SwiftUI

struct ChangePassword: View {
    
    @StateObject var profileVM = ProfileViewModel.shared
    @State private var isChecked: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 10){
                ChangePasswordField(title: "Current Password", placeholder: "Enter your current password", txt: $profileVM.txtCurrentPassword, isChecked: $isChecked)
                
                ChangePasswordField(title: "New Password", placeholder: "Enter your new password", txt: $profileVM.txtNewPassword, isChecked: $isChecked)
                
                ChangePasswordField(title: "Confirm Password", placeholder: "Confirm your new password", txt: $profileVM.txtConfirmPassword, isChecked: $isChecked)
                
                Toggle(isOn: $isChecked) {
                    Text(isChecked ? "Hide Password" : "Show Password")
                }
                .foregroundColor(.gray)
                .toggleStyle(CheckboxToggleStyle())
                
                Spacer()
                
                FilledButton(title: "Submit"){
                    profileVM.changePassword()
                }
            }
            .padding(.top)
            .frame(width: .screenWidth * 0.9, alignment: .leading)
            .navigationTitle("Change Password")
            .navigationBarTitleDisplayMode(.inline)
            .alert(Utilities.AppName, isPresented: $profileVM.showError, actions: {
                Button("Okay", role: .cancel) { }
            }, message: { Text( profileVM.errorMessage ) })
            .alert(Utilities.AppName, isPresented: $profileVM.updatedSuccess, actions: {
                Button("Okay", role: .cancel) { }
            }, message: { Text("Your password has been successfully updated!") })
        }
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
}

struct ChangePassword_Previews: PreviewProvider {
    static var previews: some View {
        ChangePassword()
    }
}
