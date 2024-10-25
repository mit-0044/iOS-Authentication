//
//  UpdateProfile.swift
//  Authentication
//
//  Created by Mit Patel on 20/09/24.
//

import SwiftUI
import Combine

struct UpdateProfile: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var profileVM = ProfileViewModel.shared
    @StateObject var imageManager = FirebaseImageManager()
    @State var selectedImage: UIImage?
    @State var isImagePickerPresented = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                if profileVM.isLoading == true {
                    ProgressView()
                        .controlSize(.large)
                        .padding(25)
                        .background(.gray.opacity(0.25))
                        .cornerRadius(20)
                }
                VStack{
                    ScrollView(.vertical, showsIndicators: false){
                        if let profileImage = imageManager.profileImage {
                            Image(uiImage: profileImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                        } else {
                            ProgressView()
                                .controlSize(.large)
                                .frame(width: 150, height: 150)
                        }
                        
                        VStack{
                            OutlineButton(title: "Change Photo", color: .colorSecondary) {
                                self.isImagePickerPresented = true
                            }
                            .padding(.bottom)
                        }
                        .frame(width: .screenWidth * 0.5, alignment: .center)
                        
                        VStack{
                            LineTextField(title: "Name", placeholder: "Enter your name", txt: $profileVM.txtName, keyboardType: .default)
                            LineTextField(title: "Email", placeholder: "Enter your email", txt: $profileVM.txtEmail, keyboardType: .emailAddress)
                                .foregroundColor(.gray)
                                .disabled(true)
                            LineTextField(title: "Contact", placeholder: "Enter your contact", txt: $profileVM.txtContact, keyboardType: .numberPad)
                            LineTextField(title: "Address", placeholder: "Enter your address", txt: $profileVM.txtAddress, keyboardType: .default)
                            
                            Spacer()
                            
                            FilledButton(title: "Submit"){
                                profileVM.isLoading = true
                                profileVM.updateProfile()
                            }
                        }
                    }
                    Spacer()
                }
            }
            .navigationTitle("Update Profile")
            .navigationBarTitleDisplayMode(.inline)
            .frame(width: .screenWidth * 0.9)
            .alert(Utilities.AppName, isPresented: $profileVM.showError, actions: {
                Button("Okay", role: .cancel) { }
            }, message: { Text( profileVM.errorMessage ) })
            .alert(Utilities.AppName, isPresented: $profileVM.isProfileUpdated, actions: {
                Button("Okay", role: .cancel) { }
            }, message: { Text( "Your profile have been updated." ) })
            .alert(Utilities.AppName, isPresented: $profileVM.updatedSuccess, actions: {
                Button("Okay", role: .cancel) { dismiss() }
            }, message: { Text( "Your details have been updated." ) })
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $selectedImage, isPresented: $isImagePickerPresented)
            }
            .onChange(of: selectedImage) { newImage in
                if let newImage = UIImage(named: "profileImage") {
                    profileVM.uploadImage(image: newImage) { result in
                        switch result {
                        case .success(let url):
                            profileVM.showError = true
                            profileVM.errorMessage = "Image uploaded successfully."
                            print("Image uploaded successfully: \(url)")
                        case .failure(let error):
                            profileVM.showError = true
                            profileVM.errorMessage = "Failed to upload image: \(error)"
                            print("Failed to upload image: \(error)")
                        }
                    }
                }
            }
        }
    }
}

struct UpdateProfile_Previews: PreviewProvider {
    static var previews: some View {
        UpdateProfile()
    }
}
