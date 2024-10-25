//
//  SideMenuViewModel.swift
//  Authentication
//
//  Created by Mit Patel on 20/09/24.
//

import SwiftUI
import FirebaseAuth

class SideMenuViewModel: ObservableObject {
    
    static var shared: SideMenuViewModel = SideMenuViewModel()
    
    @Published var txtName: String = "No Name"
    @Published var txtRole: String = "No Role"
    @Published var txtEmail: String = "No Email"
    @Published var txtProfileImage: String = "No Image"
    @Published var txtProfileInitials: String = "NN"
    @Published var logoutTapped = false
    let userId = Auth.auth().currentUser?.uid ?? ""
    
    func getDetails(){
        self.txtName = Utilities.UDString(key: "userName")
        self.txtRole = Utilities.UDString(key: "userRole")
        self.txtEmail = Utilities.UDString(key: "userEmail")
    }
}
