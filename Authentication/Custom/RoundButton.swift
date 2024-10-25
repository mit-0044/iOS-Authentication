//
//  RoundButton.swift
//  OnlineGroceriesSwiftUI
//
//  Created by Mit Patel on 02/09/24.
//

import SwiftUI

struct FilledButton: View {
    @State var title: String = "Title"
    @State var color: Color = .colorPrimary
    
    var didTap: (()->())?
    
    var body: some View {
        Button {
            didTap?()
        } label: {
            Text(title)
                .font(.customfont(.bold, fontSize: 22))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame( minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60 )
                .background(color)
                .cornerRadius(20)
        }
        .padding(.bottom, 15)
    }
}

struct OutlineButton: View {
    @State var title: String = "Title"
    @State var color: Color = .colorPrimary
    var didTap: (()->())?
    
    var body: some View {
        Button {
            didTap?()
        } label:{
            Text(title)
                .font(.customfont(.bold, fontSize: 22))
                .multilineTextAlignment(.center)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                .foregroundColor(color)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color, lineWidth: 2)
                )
        }
    }
}

struct RoundButton_Previews: PreviewProvider {
    static var previews: some View {
        FilledButton()
            .padding(20)
        OutlineButton()
            .padding(20)
    }
}
