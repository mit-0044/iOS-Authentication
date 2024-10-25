//
//  MainTabView.swift
//  Authentication
//
//  Created by Mit Patel on 16/09/24.
//

import SwiftUI

struct MainTabView: View {
    
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    @StateObject var authVM = AuthViewModel.shared;
    
    var body: some View {
        
        ZStack{
            if selectedSideMenuTab == 0 {
                Home(presentSideMenu: $presentSideMenu)
            } else if selectedSideMenuTab == 1 {
                User(presentSideMenu: $presentSideMenu)
            } else if selectedSideMenuTab == 2 {
                Setting(presentSideMenu: $presentSideMenu)
            }
            
            SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)))
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainTabView()
        }
    }
}
