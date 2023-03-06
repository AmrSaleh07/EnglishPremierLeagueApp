//
//  FixtureViewModel.swift
//  EnglishPremierLeague
//
//  Created by Amr Khafaga [Pharma] on 05/03/2023.
//

import Foundation

class FixtureViewModel: Identifiable {
    let id: Int
    let homeTeamName: String
    let homeTeamFlag: String
    let awayTeamName: String
    let awayTeamFlage: String
    let score: String?
    let status: String
    let date: String
    let utcDate: Date
    var isFavorite = true
    
    init(match: Match) {
        self.id = match.id
        homeTeamName = match.homeTeam.shortName
        awayTeamName = match.awayTeam.shortName
        homeTeamFlag = match.homeTeam.crest
        awayTeamFlage = match.awayTeam.crest
        utcDate = match.utcDate
        self.isFavorite = match.isFavorite ?? false
        
        if let homeScore = match.score.fullTime.home, let awayScore = match.score.fullTime.away {
            score = "\(homeScore) - \(awayScore)"
        } else {
            score = nil
        }
        
        switch match.status {
        case .finished:
            status = "Finished"
        case .postponed:
            status = "Postponed"
        case .scheduled:
            status = "Scheduled"
        case .timed:
            status = "In progress"
        case .inPlay:
            status = "In Play"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH:mm"
        date = dateFormatter.string(from: match.utcDate)
    }
}
