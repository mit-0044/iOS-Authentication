//
//  ProfileViewModel.swift
//  Authentication
//
//  Created by Mit Patel on 18/09/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileViewModel: ObservableObject {
    
    static var shared: ProfileViewModel = ProfileViewModel()
    @StateObject var authVM = AuthViewModel.shared
    
    let userId = Auth.auth().currentUser?.uid ?? ""
    let storage = Storage.storage()
    let db = Firestore.firestore()
    
    @Published var txtNameLabel: String = "No Name Label"
    @Published var txtUserId: String = "No User ID"
    @Published var txtName: String = "No Name"
    @Published var txtRole: String = "No Role"
    @Published var txtEmail: String = "No Email"
    @Published var txtContact: String = "No Contact"
    @Published var txtAddress: String = "No Address"
    @Published var txtProfileImage: String = ""
    @Published var txtProfileInitials: String = ""
    @Published var isProfileUpdated: Bool = false
    
    @Published var txtCurrentPassword: String = ""
    @Published var updatedSuccess: Bool = false
    @Published var txtNewPassword: String = ""
    @Published var txtConfirmPassword: String = ""
    @Published var isShowPassword: Bool = false
    
    @Published var deleteTapped = false
    @Published var logoutTapped = false
    
    @Published var isLoading: Bool = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    func getDetails(){
        self.txtNameLabel = self.txtName
        self.txtName = Utilities.UDString(key: "userName")
        self.txtRole = Utilities.UDString(key: "userRole")
        self.txtEmail = Utilities.UDString(key: "userEmail")
        self.txtContact = Utilities.UDString(key: "userContact")
        self.txtAddress = Utilities.UDString(key: "userAddress")
    }
    
    //MARK: Update Profile
    func updateProfile(){
        if txtName.isEmpty {
            self.showError = true
            self.isLoading = false
            self.errorMessage = "Please enter your name."
            return
        }else if !Utilities.isValidContact(txtContact){
            self.showError = true
            self.isLoading = false
            self.errorMessage = "Please enter valid contact no. with 10 digits only."
            return
        }else if txtAddress.isEmpty {
            self.showError = true
            self.isLoading = false
            self.errorMessage = "Please enter your address."
            return
        }else{
            let doc =  db.collection("users").document(userId)
            
            let data = [
                "name": self.txtName,
                "contact": self.txtContact,
                "address": self.txtAddress
            ]
            doc.setData(data, merge: true) { error in
                if let error = error {
                    print("Error writing document: \(error)")
                } else {
                    print("Document successfully updated!")
                    self.updateSession()
                    self.isLoading = false
                    self.updatedSuccess = true
                }
            }
        }
    }
    
    //MARK: Update Session
    func updateSession(){
        db.collection("users").document(userId).getDocument { snapshot, error in
            if error != nil {
                print("Fetch User Error: \(error!.localizedDescription)")
            } else {
                Utilities.UDSET(data: snapshot?.get("name") as! String, key: "userName")
                Utilities.UDSET(data: snapshot?.get("contact") as! String, key: "userContact")
                Utilities.UDSET(data: snapshot?.get("role") as! String, key: "userRole")
                Utilities.UDSET(data: snapshot?.get("email") as! String, key: "userEmail")
                Utilities.UDSET(data: snapshot?.get("address") as! String, key: "userAddress")
            }
        }
    }
    
    // Function to upload the image
    func uploadImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to JPEG.")
            self.isLoading = false
            self.showError = true
            self.errorMessage = "Failed to convert image to JPEG."
            return
        }
        
        let storageRef = storage.reference().child("profileImage/\(userId).jpg")
        
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                self.isLoading = false
                self.showError = true
                self.errorMessage = "Error uploading image: \(error.localizedDescription)"
                completion(.failure(error))
                return
            }
            
            // Get the download URL
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    self.isLoading = false
                    self.showError = true
                    self.errorMessage = "Error getting download URL: \(error.localizedDescription)"
                    completion(.failure(error))
                    return
                }
                
                if let imageUrl = url?.absoluteString {
                    print("Image URL: \(imageUrl)")
                    completion(.success(imageUrl))
                    self.saveImageUrlToFirestore(imageUrl: imageUrl)
                }
            }
        }
    }
    
    // Save the image URL in Firestore
    func saveImageUrlToFirestore(imageUrl: String) {
        db.collection("users").document(userId).updateData(["profileImage": imageUrl]) { error in
            if let error = error {
                print("Error updating Firestore document: \(error.localizedDescription)")
                self.isLoading = false
                self.showError = true
                self.errorMessage = "Error updating Firestore document: \(error.localizedDescription)"
            } else {
                print("Image URL successfully updated in Firestore.")
                self.isLoading = false
                self.isProfileUpdated = true
            }
        }
    }
    
    //MARK: Change password
    func changePassword(){
        if Utilities.isValidPassword(txtCurrentPassword) {
            self.showError = true
            self.errorMessage = "Please enter valid current password with minimum 8 characters at least 1 Alphabet, 1 Number and 1 Special Character."
            return
        }else if(txtConfirmPassword != txtNewPassword) {
            self.showError = true
            self.errorMessage = "Confirm password does not match."
            return
        }else {
            guard let user = Auth.auth().currentUser else {
                self.showError = true
                self.errorMessage = "No user is signed in."
                return
            }
            let credential = EmailAuthProvider.credential(withEmail: user.email ?? "", password: self.txtCurrentPassword)
            
            user.reauthenticate(with: credential) { result, error in
                if let error = error {
                    self.showError = true
                    self.errorMessage = "Re-authentication failed: \(error.localizedDescription)"
                    return
                }
                
                user.updatePassword(to: self.txtNewPassword) { error in
                    if let error = error {
                        self.showError = true
                        self.errorMessage = "Password change failed: \(error.localizedDescription)"
                        return
                    }
                    self.updatedSuccess = true
                }
            }
        }
    }
}

