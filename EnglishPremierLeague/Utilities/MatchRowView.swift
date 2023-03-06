//
//  MatchRowView.swift
//  EnglishPremierLeague
//
//  Created by Amr Khafaga [Pharma] on 07/03/2023.
//

import SwiftUI

struct MatchRowView: View {
    let match: FixtureViewModel
    let addToFavitouteAction: (() -> Void)
    
    init(match: FixtureViewModel, addToFavitouteAction: @escaping () -> Void) {
        self.match = match
        self.addToFavitouteAction = addToFavitouteAction
    }
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 10) {
            Button(action: {
                self.addToFavitouteAction()
            }) {
                Image(systemName: match.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(match.isFavorite ? .red : .gray)
            }
            
            Text(match.homeTeamName)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.custom("Helvetica", size: 13))
                .fontWeight(.semibold)
            
            NetworkImageView(withURL: match.homeTeamFlag,
                             imageHeight: 20,
                             imageWidth: 20)
            
            if let score = match.score {
                Text(score)
            } else {
                Text(match.date)
            }
            
            NetworkImageView(withURL: match.awayTeamFlage,
                             imageHeight: 20,
                             imageWidth: 20)
            
            Text(match.awayTeamName)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("Helvetica", size: 13))
                .fontWeight(.semibold)
        }
    }
}
