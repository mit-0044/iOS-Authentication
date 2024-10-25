//
//  LineTextField.swift
//  Authentication
//
//  Created by Mit Patel on 02/09/24.
//

import SwiftUI

struct LineTextField: View {
    @State var title: String
    @State var placeholder: String
    @Binding var txt: String
    @State var keyboardType: UIKeyboardType = .default
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.customfont(.semibold, fontSize: 16))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)

            TextField(placeholder, text: $txt)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .focused($isTextFieldFocused)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                .onTapGesture {
                    isTextFieldFocused = true
                }

            Divider()
        }
        .padding(.bottom)
        .frame(maxWidth: .screenWidth * 0.9)
    }
}

struct LineSecureField: View {
    @State var title: String = "Title"
    @State var placeholder: String = "Placholder"
    @Binding var txt: String
    @Binding var isShowPassword: Bool
    
    var body: some View {
        VStack(spacing: 3){
            Text(title)
                .font(.customfont(.semibold, fontSize: 16))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                if isShowPassword {
                    TextField(placeholder, text: $txt)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                } else {
                    SecureField(placeholder, text: $txt)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                }

                Button(action: {
                    isShowPassword.toggle()
                }) {
                    Image(systemName: isShowPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
            
            Divider()
        }
        .padding(.bottom)
    }
}

struct ChangePasswordField: View {
    @State var title: String = "Title"
    @State var placeholder: String = "Placholder"
    @Binding var txt: String
    @Binding var isChecked: Bool
    
    var body: some View {
        VStack(spacing: 3){
            Text(title)
                .font(.customfont(.semibold, fontSize: 16))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if (isChecked) {
                TextField(placeholder, text: $txt)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            }else{
                SecureField(placeholder, text: $txt)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            }
            Divider()
        }
        .padding(.bottom)
    }
}

struct LineTextField_Previews: PreviewProvider {
    @State static  var txt: String = ""
    @State static  var title: String = ""
    @State static  var placeholder: String = ""
    static var previews: some View {
        LineTextField(title: title, placeholder: placeholder, txt: $txt)
    }
}
struct LineSecureField_Previews: PreviewProvider {
    @State static  var txt: String = ""
    @State static  var isShowPassword: Bool = false
    static var previews: some View {
        LineSecureField(txt: $txt, isShowPassword: $isShowPassword)
    }
}
