//
//  MainTabView.swift
//  Authentication
//
//  Created by Mit Patel on 02/09/24.
//

import SwiftUI
import FirebaseAuth

struct Home: View {
    
    @StateObject var homeVM = HomeViewModel.shared
    @StateObject var authVM = AuthViewModel.shared
    @StateObject var sideMenuVM = SideMenuViewModel.shared
    @Binding var presentSideMenu: Bool
    
    var body: some View {
        let imageManager = FirebaseImageManager()
        
        let data = [
            CardData(title: "\(homeVM.countUsers + homeVM.countAdmins)", subtitle: "Total", icon: "person.3.fill"),
            CardData(title: "\(homeVM.countAdmins)", subtitle: "Admins", icon: "person.badge.key.fill"),
            CardData(title: "\(homeVM.countUsers)", subtitle: "Users", icon: "person.fill")
        ]
        let columns: [GridItem] = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ]
        
        NavigationView {
            ZStack{
                if homeVM.isLoading == true {
                    ProgressView()
                        .controlSize(.large)
                        .padding(25)
                        .background(.gray.opacity(0.25))
                        .cornerRadius(20)
                } else if homeVM.isLoading == false {
                    VStack{
                        if homeVM.txtRole == "Admin" {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(data) { item in
                                    CardView(title: item.title, subtitle: item.subtitle, icon: item.icon)
                                }
                            }
                        }else if homeVM.txtRole == "User"{
                            Spacer()
                            Image("dashboard")
                                .resizable()
                                .scaledToFit()
                                .frame(width: .screenWidth * 0.9)
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding(.top, .topInsets)
                    .padding(.top)
                } else {
                    Text("Failed to load data")
                }
            }
            .onAppear {
                homeVM.fetchUser()
                homeVM.fetchCounts()
                imageManager.fetchProfileImage()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    sideMenuVM.getDetails()
                }
            }
            .frame(width: .screenWidth * 0.9, height: .screenHeight)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
                        presentSideMenu.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.primary)
                            .frame(width: .screenWidth * 0.075)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        authVM.logoutTapped.toggle()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.primary)
                            .frame(width: .screenWidth * 0.075)
                    }
                }
            }
            .alert(isPresented: $authVM.logoutTapped) {
                Alert(
                    title: Text(Utilities.AppName),
                    message: Text( "Are you sure want to logout?" ),
                    primaryButton: .destructive(Text("Logout")){
                        authVM.logout()
                        homeVM.isLoading = true
                    },
                    secondaryButton: .default(Text("Cancel"))
                )
            }
            .fullScreenCover(isPresented: $authVM.isLoggedOut) {
                Login()
            }
        }
    }
}
struct Home_Previews: PreviewProvider {
    @State static var presentSideMenu = false
    static var previews: some View {
        Home(presentSideMenu: $presentSideMenu)
    }
}
