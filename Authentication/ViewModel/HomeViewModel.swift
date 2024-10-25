//
//  HomeViewModel.swift
//  Authentication
//
//  Created by Mit Patel on 16/09/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

class HomeViewModel: ObservableObject
{
    static var shared: HomeViewModel = HomeViewModel()
    let db = Firestore.firestore()
    let userId = Auth.auth().currentUser?.uid ?? ""
    
    @Published var selectTab: Int = 0
    @Published var countUsers: Int = 0
    @Published var countAdmins: Int = 0
    @Published var txtSearch: String = ""
    @Published var isLoading: Bool = true
    
    @Published var txtRole: String = ""
    @Published var txtName: String = ""
    @Published var txtEmail: String = ""
    @Published var txtContact: String = ""
    
    @Published var showError = false
    @Published var errorMessage = ""
    
    
    //MARK: Fetch User
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Error: Unable to fetch user UID.")
            showError = true
            errorMessage = "Error: Unable to fetch user UID."
            return
        }
        
        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Fetch User Error: \(error.localizedDescription)")
                self.showError = true
                self.errorMessage = "Fetch User Error: \(error.localizedDescription)"
                return
            }
            
            guard let data = snapshot?.data() else {
                print("Error: No user data found.")
                self.showError = true
                self.errorMessage = "No user data found."
                return
            }
            
            let user = UserModel(
                role: data["role"] as? String ?? "Unknown",
                name: data["name"] as? String ?? "Unknown",
                email: data["email"] as? String ?? "Unknown",
                contact: data["contact"] as? String ?? "Unknown",
                address: data["address"] as? String ?? "Unknown"
            )
            
            DispatchQueue.main.async {
                self.updateUserDefaults(with: user)
                
            }
        }
    }
    
    func saveImageToUserDefaults(image: UIImage, key: String) {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            UserDefaults.standard.set(imageData, forKey: key)
        }
    }
    
    func updateUserDefaults(with user: UserModel) {
        Utilities.UDSET(data: user.name, key: "userName")
        Utilities.UDSET(data: user.contact, key: "userContact")
        Utilities.UDSET(data: user.role, key: "userRole")
        Utilities.UDSET(data: user.email, key: "userEmail")
        Utilities.UDSET(data: user.address, key: "userAddress")
        self.txtRole = user.role
        self.isLoading = false
    }
    
    func fetchCounts() {
        db.collection("users")
        .whereField("role", isEqualTo: "User")
        .getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting user documents: \(error)")
            } else {
                self.countUsers = querySnapshot?.documents.count ?? 0
            }
        }
        
        db.collection("users")
        .whereField("role", isEqualTo: "Admin")
        .getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting admin documents: \(error)")
            } else {
                self.countAdmins = querySnapshot?.documents.count ?? 0
            }
        }
        
        self.isLoading = false
    }
}
