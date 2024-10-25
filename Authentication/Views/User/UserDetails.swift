//
//  UserDetails.swift
//  Authentication
//
//  Created by Mit Patel on 18/09/24.
//

import SwiftUI

struct UserDetails: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var userVM = UserViewModel.shared
    var selectedUser: UserModel
    
    var body: some View {
        let imageManager = FirebaseImageManager()
        NavigationStack {
            VStack{
                VStack{
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
                        Text(selectedUser.name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                        Text(selectedUser.role)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary.opacity(0.5))
                    }
                }
                .padding(.vertical, .screenWidth * 0.025)
                
                VStack(alignment: .leading, spacing: 15) {
                    DetailsInfoRow(image: "person.fill", title: selectedUser.name)
                    DetailsInfoRow(image: "envelope.fill", title: selectedUser.email)
                    DetailsInfoRow(image: "phone.fill", title: selectedUser.contact)
                    DetailsInfoRow(image: "house.fill", title: selectedUser.address)
                }
                .padding(.vertical, .screenWidth * 0.025)
                .padding(.bottom)
                
                Spacer()
            }
            .navigationTitle("User Details")
            .navigationBarTitleDisplayMode(.inline)
            .frame(width: .screenWidth * 0.9)
        }
    }
}

struct DetailsInfoRow: View {
    var image: String
    var title: String
    
    var body: some View {
        HStack(spacing: 20){
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(.colorPrimary)
            Text(title)
            Spacer()
        }
        .padding([.leading, .bottom], 5)
    }
}

struct UserDetails_Previews: PreviewProvider {
    @State static var user = UserModel()
    static var previews: some View {
        UserDetails(selectedUser: user)
    }
}
