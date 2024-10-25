//
//  AccountView.swift
//  Authentication
//
//  Created by Mit Patel on 16/09/24.
//

import SwiftUI

struct Profile: View {
    
    @StateObject var profileVM = ProfileViewModel.shared
    
    var body: some View {
        
        let imageManager = FirebaseImageManager()
        
        NavigationStack {
            ZStack{
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
                        VStack(){
                            Text(profileVM.txtName)
                                .font(.customfont(.bold, fontSize: 24))
                            Text(profileVM.txtRole)
                                .font(.customfont(.bold, fontSize: 18))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 25) {
                        ProfileInfoRow(image: "person.fill", title: profileVM.txtName)
                        ProfileInfoRow(image: "envelope.fill", title: profileVM.txtEmail)
                        ProfileInfoRow(image: "phone.fill", title: profileVM.txtContact)
                        ProfileInfoRow(image: "house.fill", title: profileVM.txtAddress)
                    }
                    .padding(.vertical, .screenWidth * 0.025)
                    
                    Spacer()
                    
                    VStack(){
                        NavigationLink {
                            UpdateProfile()
                        } label: {
                            Text("Edit Profile")
                                .font(.customfont(.bold, fontSize: 22))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, minHeight: 60)
                                .background(.colorPrimary)
                                .cornerRadius(20)
                        }
                        NavigationLink {
                            ChangePassword()
                        } label: {
                            Text("Change Password")
                                .font(.customfont(.bold, fontSize: 22))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, minHeight: 60)
                                .background(.colorSecondary)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.bottom, 15)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .frame(width: .screenWidth * 0.9)
        }
    }
}

struct ProfileInfoRow: View {
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
                .font(.customfont(.regular, fontSize: 16))
            Spacer()
        }
        .padding([.leading, .bottom], 5)
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
