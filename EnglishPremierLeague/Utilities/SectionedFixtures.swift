//
//  SectionedFixtures.swift
//  EnglishPremierLeague
//
//  Created by Amr Khafaga [Pharma] on 07/03/2023.
//

import Foundation

struct SectionedFixtures: Identifiable {
    let id = UUID()
    let title: String
    let matches: [FixtureModel]
}
