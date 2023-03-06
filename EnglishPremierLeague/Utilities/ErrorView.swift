//
//  ErrorView.swift
//  EnglishPremierLeague
//
//  Created by Amr Khafaga [Pharma] on 06/03/2023.
//

import SwiftUI

struct ErrorView: View {
    let type: ErrorViewType
    let action: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(type.image)
                .resizable()
                .scaledToFit()
                .frame(width: 155, height: 195)
            
            Text(type.title)
                .foregroundColor(.gray)
                .font(.title3)
                .padding(.top, 16)
            
            Text(type.subtitle)
                .foregroundColor(.gray)
                .font(.subheadline)
                .multilineTextAlignment(.center)
            
            Button(action: action) {
                Text(type.buttonTitle)
                    .frame(width: 100, height: 20)
                    .foregroundColor(.white)
                    .padding(16)
                    .background(Color.purple)
                    .cornerRadius(10)
                   
            }
            .padding(.top, 16)
            
            Spacer()
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(type: .technicalError, action: {})
    }
}
