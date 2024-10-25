//
//  Setting.swift
//  Authentication
//
//  Created by Mit Patel on 07/10/24.
//

import SwiftUI
import FirebaseAuth

struct Setting: View {
    
    @Binding var presentSideMenu: Bool
    @EnvironmentObject var appearanceSetting: AppearanceSettings
    @StateObject var profileVM = ProfileViewModel.shared
    
    var body: some View {
        
        let imageManager = FirebaseImageManager()
        
        NavigationStack {
            Form {
                Group {
                    NavigationLink {
                        Profile()
                    } label: {
                        HStack{
                            if let profileImage = imageManager.profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 75, height: 75)
                                    .clipShape(Circle())
                            } else {
                                ProgressView()
                                    .frame(width: 75, height: 75)
                            }
                            VStack(alignment: .leading){
                                Text(profileVM.txtName)
                                    .font(.customfont(.bold, fontSize: 24))
                                Text(profileVM.txtRole)
                                    .font(.customfont(.bold, fontSize: 18))
                                    .foregroundColor(.gray)
                            }
                            .frame(alignment: .leading)
                        }
                    }
                }
                
                Section{
                    HStack{
                        VStack{
                            Image(systemName: "sun.max")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.white)
                        }
                        .frame(width: 25, height: 25)
                        .background(Color.blue)
                        .cornerRadius(5, corner: .allCorners)
                        
                        NavigationLink(destination: AppearanceSettingsView()) {
                            Text("Appearance")
                        }
                    }
                    HStack{
                        VStack{
                            Image(systemName: "lock.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                        }
                        .frame(width: 25, height: 25)
                        .background(Color.green)
                        .cornerRadius(5, corner: .allCorners)
                        
                        NavigationLink(destination: Passcode()) {
                            Text("Passcode")
                        }
                    }
                }
            }
            .onAppear {
                profileVM.getDetails()
            }
            .navigationBarTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
                        DispatchQueue.main.async {
                            presentSideMenu.toggle()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.primary)
                            .frame(width: .screenWidth * 0.075)
                    }
                }
            }
        }
    }
}

struct Setting_Previews: PreviewProvider {
    @State static var presentSideMenu = false
    static var previews: some View {
        Setting(presentSideMenu: $presentSideMenu)
            .environmentObject(AppearanceSettings())
    }
}
