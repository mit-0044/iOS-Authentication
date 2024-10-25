//
//  UserRowView.swift
//  Authentication
//
//  Created by Mit Patel on 18/09/24.
//

import SwiftUI

struct UserRowView: View {
    var name: String
    var email: String
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading, spacing: 2){
                    Text(name)
                        .font(.customfont(.bold, fontSize: 22))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    Text(email)
                        .font(.customfont(.medium, fontSize: 16))
                        .foregroundColor(.gray.opacity(0.75))
                        .lineLimit(1)
                        .padding(.bottom, 10)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray.opacity(0.75))
            }
            Divider()
        }
        .frame(width: .screenWidth * 0.9, alignment: .leading)
    }
}

struct UserRowView_Previews: PreviewProvider {
    @State static var name = ""
    @State static var email = ""
    static var previews: some View {
        UserRowView(name: name, email: email)
    }
}
