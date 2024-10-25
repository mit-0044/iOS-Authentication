//
//  Login.swift
//  Authentication
//
//  Created by Mit Patel on 31/08/24.
//

import SwiftUI

struct Login: View {
    
    @StateObject var authVM = AuthViewModel.shared;
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                if authVM.isLoading == true {
                    ProgressView("Logging")
                        .controlSize(.large)
                        .padding(25)
                        .background(.gray.opacity(0.25))
                        .cornerRadius(20)
                }
                VStack{
                    ScrollView(.vertical, showsIndicators: false){
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: .screenWidth * 0.75)
                            .padding(.bottom, .screenWidth * 0.1)
                        
                        Text("Login")
                            .font(.customfont(.arial, fontSize: 26))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 4)
                        
                        Text("Enter your email and password")
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundColor(.colorSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 15)
                        
                        LineTextField( title: "Email", placeholder: "Enter your email address", txt: $authVM.txtEmail, keyboardType: .emailAddress)
                        
                        LineSecureField( title: "Password", placeholder: "Enter your password", txt: $authVM.txtPassword, isShowPassword: $authVM.isShowPassword)
                        
                        FilledButton(title: "Login") {
                            authVM.isLoading = true
                            authVM.login()
                        }
                        
                        NavigationLink {
                            SignUp()
                        } label: {
                            HStack{
                                Text("Don’t have an account?")
                                    .font(.customfont(.semibold, fontSize: 16))
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                Text("SignUp")
                                    .font(.customfont(.semibold, fontSize: 18))
                                    .foregroundColor(.blue)
                            }
                        }
                        Spacer()
                    }
                    .padding(.top, .topInsets + 50)
                    .frame(width: .screenWidth * 0.9)
                    Spacer()
                }
            }
            .ignoresSafeArea()
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .fullScreenCover(isPresented: $authVM.isLoggedIn) {
                MainTabView()
            }
            .alert(Utilities.AppName, isPresented: $authVM.showError) {
                Button("Okay") {}
            } message: {
                Text(authVM.errorMessage)
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

