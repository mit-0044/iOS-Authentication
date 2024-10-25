//
//  UserModel.swift
//  Authentication
//
//  Created by Mit Patel on 02/09/24.
//

import SwiftUI

struct UserModel: Identifiable, Equatable, Codable {
    var id: String = ""
    var role: String = ""
    var name: String = ""
    var email: String = ""
    var contact: String = ""
    var address: String = ""
    var gender: String = ""
    var profileImage: String = ""
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: name) {
            formatter.style = .abbreviated
            return formatter.string(from:components)
        }
        return ""
    }
}
