//
//  SideMenu.swift
//  Authentication
//
//  Created by Mit Patel on 16/09/24.
//

import SwiftUI
import FirebaseAuth

struct SideMenu: View {
    @Binding var isShowing: Bool
    var content: AnyView
    var edgeTransition: AnyTransition = .move(edge: .leading)
    var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                content
                    .transition(edgeTransition)
                    .background(
                        Color.clear
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}

struct SideMenuView: View {
    @Binding var selectedSideMenuTab: Int
    @Binding var presentSideMenu: Bool
    @StateObject var sideMenuVM = SideMenuViewModel.shared
    
    var body: some View {
        HStack {
            ZStack{
                VStack(alignment: .leading, spacing: 10) {
                    ProfileImageView()
                        .padding(.vertical, 10)
                        .frame(width: .screenWidth * 0.7, alignment: .leading)
                    
                    ScrollView {
                        VStack{
                            RowView(isSelected: selectedSideMenuTab == 0, imageName: "house", title: "Home") {
                                selectedSideMenuTab = 0
                                presentSideMenu.toggle()
                            }
                            if sideMenuVM.txtRole == "Admin" {
                                RowView(isSelected: selectedSideMenuTab == 1, imageName: "person.3.fill", title: "User") {
                                    selectedSideMenuTab = 1
                                    presentSideMenu.toggle()
                                }
                            }
                            RowView(isSelected: selectedSideMenuTab == 2, imageName: "gear", title: "Setting") {
                                selectedSideMenuTab = 2
                                presentSideMenu.toggle()
                            }
                        }
                        .padding(.trailing, .screenWidth * 0.07)
                    }
                    Spacer()
                }
                .frame(width: .screenWidth * 0.7)
                .background(Color.colorSidebar)
            }
            Spacer()
        }
        .padding(.top, .topInsets)
        .ignoresSafeArea()
    }
    
    func RowView(isSelected: Bool, imageName: String, title: String, hideDivider: Bool = false, action: @escaping (()->())) -> some View{
        Button{
            action()
        } label: {
            VStack(alignment: .leading){
                HStack(spacing: 10){
                    ZStack{
                        Image(systemName: imageName)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(isSelected ? .black : .white)
                            .frame(width: 30)
                            .padding(.leading)
                    }
                    .frame(width: 40, height: 30)
                    Text(title)
                        .font(.customfont(.arial, fontSize: 22))
                        .foregroundColor(isSelected ? .black : .white)
                        .padding(.leading)
                    Spacer()
                }
            }
        }
        .frame(height: 50)
        .background(
            ZStack{
                if isSelected == true {
                    Color.white
                        .clipShape(CustomCorners(radius: 12.5, corners:
                                                    [.topRight, .bottomRight]))
                }else{
                    Color.colorSidebar
                }
            }
        )
    }
}

struct ProfileImageView: View {
    @StateObject var sideMenuVM = SideMenuViewModel.shared
    @StateObject var imageManager = FirebaseImageManager()
    var body: some View {
        HStack{
            if let profileImage = imageManager.profileImage{
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
                Text(sideMenuVM.txtName)
                    .font(.customfont(.bold, fontSize: 24))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Text(sideMenuVM.txtRole)
                    .font(.customfont(.bold, fontSize: 18))
                    .foregroundColor(.gray)
            }
            .frame(alignment: .leading)
        }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    @State static var selectedSideMenuTab = 0
    @State static var presentSideMenu = false
    static var previews: some View {
        NavigationView {
            SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)
        }
    }
}
