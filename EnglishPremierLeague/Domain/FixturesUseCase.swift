//
//  FixturesUseCase.swift
//  EnglishPremierLeague
//
//  Created by Amr Khafaga [Pharma] on 05/03/2023.
//

import Foundation

protocol FetchFixturesUseCase {
    func execute(completion: @escaping (Result<[Match], Error>) -> Void)
}

class DefaultFetchFixturesUseCase: FetchFixturesUseCase {
    private let fixturesRepository: FixturesRepository
    
    init(fixturesRepository: FixturesRepository) {
        self.fixturesRepository = fixturesRepository
    }
    
    func execute(completion: @escaping (Result<[Match], Error>) -> Void) {
        let apiKey = "2286498366514f70b2d1fcddb27925a6"
        _ = KeychainManager.saveApiKey(apiKey)
        fixturesRepository.fetchFixtures(completion: completion)
    }
}
