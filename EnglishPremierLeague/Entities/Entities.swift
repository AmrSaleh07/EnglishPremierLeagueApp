//
//  Entities.swift
//  EnglishPremierLeague
//
//  Created by Amr Khafaga [Pharma] on 05/03/2023.
//

import Foundation

enum Status: String, Codable {
    case finished = "FINISHED"
    case inPlay = "IN_PLAY"
    case postponed = "POSTPONED"
    case scheduled = "SCHEDULED"
    case timed = "TIMED"
}

//struct Match: Codable {
//    let id: Int
//    let utcDate: Date
//    let status: Status
//    let homeTeam, awayTeam: Team
//    let score: Score
//    var isFavorite: Bool? = false
//}

struct Match: Codable {
    let id: Int
    let utcDate: Date
    let status: Status
    let homeTeam, awayTeam: Team
    let score: Score
    var isFavorite: Bool? = false
}

// MARK: - Team
struct Team: Codable {
    let id: Int
    let name, shortName, tla: String
    let crest: String
}

// MARK: - Score
struct Score: Codable {
    let fullTime, halfTime: Time
}

// MARK: - Time
struct Time: Codable {
    let home, away: Int?
}

struct FixturesResponse: Codable {
    let matches: [Match]
}
