//
//  LoadingView.swift
//  EnglishPremierLeague
//
//  Created by Amr Khafaga [Pharma] on 07/03/2023.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                
                Text("Loading English Premier League...")
                    .font(.headline)
                    .padding()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .foregroundColor(.green)
            }
        }
    }
}


struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
