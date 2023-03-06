//
//  NoDataView.swift
//  EnglishPremierLeague
//
//  Created by Amr Khafaga [Pharma] on 07/03/2023.
//

import SwiftUI

struct NoFavoritesView: View {
    var body: some View {
        VStack {
            Image(systemName: "star.slash")
                .font(.largeTitle)
                .padding(.bottom, 16)
            
            Text("No favorite fixtures")
                .font(.title)
                .padding(.bottom, 8)
            
            Text("You haven't favorited any fixtures yet.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .foregroundColor(.secondary)
        }
    }
}

struct NoFavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        NoFavoritesView()
    }
}
