//
//  FixturesRepository.swift
//  EnglishPremierLeague
//
//  Created by Amr Khafaga [Pharma] on 05/03/2023.
//

import Foundation
import Moya

protocol FixturesRepositoryProtocol {
    func fetchFixtures(completion: @escaping (Result<[Match], Error>) -> Void)
}

class FixturesRepository: FixturesRepositoryProtocol {
    let provider: MoyaProvider<FixturesAPI>
    
    init(provider: MoyaProvider<FixturesAPI>) {
        self.provider = provider
    }
    
    func fetchFixtures(completion: @escaping (Result<[Match], Error>) -> Void) {
        provider.request(.fixtures) { result in
            switch result {
            case let .success(response):
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let fixturesResponse = try decoder.decode(FixturesResponse.self, from: response.data)
                    completion(.success(fixturesResponse.matches))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
