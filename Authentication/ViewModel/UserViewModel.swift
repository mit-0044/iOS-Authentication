//
//  UserViewModel.swift
//  Authentication
//
//  Created by Mit Patel on 18/09/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class UserViewModel: ObservableObject {
    
    static var shared: UserViewModel = UserViewModel()
    let db = Firestore.firestore()
    let userId = Auth.auth().currentUser?.uid ?? ""
    
    @Published var selectTab: Int = 1
    @Published var txtSearch: String = ""
    
    @Published var txtName: String = ""
    @Published var txtRole: String = "User"
    @Published var txtEmail: String = ""
    @Published var txtContact: String = ""
    @Published var txtAddress: String = ""
    @Published var txtPassword: String = "Password@123"
    @Published var txtProfileImage: String = ""
    
    @Published var users = [UserModel]()
    
    @Published var isLoading = false
    @Published var isImageUploaded = false
    
    @Published var isUserAdded = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    
    //MARK: User()
    func fetchUserLists() {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No Users")
                return
            }
            
            self.users = documents.map { queryDocumentSnapshot -> UserModel in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as! String
                let role = data["role"] as! String
                let name = data["name"] as! String
                let email = data["email"] as! String
                let contact = data["contact"] as! String
                let address = data["address"] as! String
                
                return UserModel(id: id, role: role, name: name, email: email, contact: contact, address: address)
            }
        }
    }
    
}
