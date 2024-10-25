//
//  UserList.swift
//  Authentication
//
//  Created by Mit Patel on 16/09/24.
//

import SwiftUI
import FirebaseAuth

struct User: View {
    
    @Binding var presentSideMenu: Bool
    @StateObject var userVM = UserViewModel.shared
    
    var body: some View {
        
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack(spacing: 15) {
                    ForEach(userVM.users.filter { userVM.txtSearch.isEmpty ? true : ($0.name.localizedCaseInsensitiveContains(userVM.txtSearch) ||
                                                                                     $0.email.localizedCaseInsensitiveContains(userVM.txtSearch))
                    }) { user in
                        NavigationLink(destination: UserDetails(selectedUser: user)) {
                            UserRowView(name: user.name, email: user.email)
                        }
                    }
                }
                .frame(width: .screenWidth * 0.9)
                .navigationTitle("Users")
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
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            AddUser()
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: .screenWidth * 0.05)
                        }
                    }
                }
                .searchable(
                    text: $userVM.txtSearch,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search User"
                )
                .textInputAutocapitalization(.never)
            }
        }
        .onAppear() {
            userVM.fetchUserLists()
        }
    }
}

struct User_Previews: PreviewProvider {
    @State static var presentSideMenu = false
    @State static var hideTabBar = false
    static var previews: some View {
        User(presentSideMenu: $presentSideMenu)
    }
}
