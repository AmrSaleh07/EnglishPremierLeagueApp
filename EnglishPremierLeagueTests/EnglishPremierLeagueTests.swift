//
//  EnglishPremierLeagueTests.swift
//  EnglishPremierLeagueTests
//
//  Created by Amr Khafaga [Pharma] on 15/03/2023.
//

import XCTest
import Moya
import Combine
@testable import EnglishPremierLeague

class FixturesViewModelTests: XCTestCase {

    var viewModel: FixturesViewModel!
    var useCase: MockFetchFixturesUseCase!
    var subscriptions = Set<AnyCancellable>()
    var provider: MoyaProvider<FixturesAPI>!
    
    override func setUp() {
        super.setUp()
        self.provider = MoyaProvider<FixturesAPI>()
        useCase = MockFetchFixturesUseCase(fixturesRepository: FixturesRepositoryMock(provider: provider))
        viewModel = FixturesViewModel(fixturesUseCase: useCase)
    }
    
    override func tearDown() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        viewModel = nil
        useCase = nil
        super.tearDown()
    }
    
    func test_fetchFixtures_success() {
        let expectation = XCTestExpectation(description: "Fetch fixtures should complete successfully")
        useCase.result = .success([])
        
        viewModel.state = .loading
        
        viewModel.$state
            .sink { state in
                if state == .loaded {
                    expectation.fulfill()
                }
            }
            .store(in: &subscriptions)
        
        viewModel.didLoad.send()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_fetchFixtures_failure() {
        let expectation = XCTestExpectation(description: "Fetch fixtures should fail")
        useCase.result = .failure(ErrorViewType.technicalError)
        
        viewModel.state = .loading
        
        viewModel.$state
            .sink { state in
                if state != .loaded && state != .loading {
                    expectation.fulfill()
                }
            }
            .store(in: &subscriptions)
        
        viewModel.didLoad.send()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_toggleFavorite() {
        let match = FixtureModel(match: Match.mock)
        XCTAssertFalse(match.isFavorite)
        XCTAssertFalse(viewModel.favoriteMatches.contains(match.id))
        
        viewModel.toggleFavorite(for: match)
        
        XCTAssertTrue(match.isFavorite)
        XCTAssertTrue(viewModel.favoriteMatches.contains(match.id))
        
        viewModel.toggleFavorite(for: match)
        
        XCTAssertFalse(match.isFavorite)
        XCTAssertFalse(viewModel.favoriteMatches.contains(match.id))
    }
    
    func test_updateData() {
        let matches = [Match.mock, Match.mock, Match.mock]
        let matchesVMs = matches.map { FixtureModel(match: $0) }
        
        viewModel.updateData(matches)
        
        XCTAssertEqual(viewModel.fixtures.count, 1)
        XCTAssertEqual(viewModel.fixtures[viewModel.fixtures.keys.first!], matchesVMs)
    }
    
    func test_createFixturesVMs() {
        let match = Match.mock
        let fixtureVM = FixtureModel(match: match)
        let matches = [match]
        
        XCTAssertEqual(viewModel.createFixturesVMs(matches), [fixtureVM])
    }
    
    func test_showFavoritesOnly() {
        let matches = [Match.mock, Match.mock, Match.mock]
        let matchesVMs = matches.map { FixtureModel(match: $0) }
        
        viewModel.updateData(matches)
        viewModel.isShowingFavoritesOnly = true
        
        XCTAssertEqual(viewModel.fixtures.count, 1)
        
        viewModel.favoriteMatches.insert(matches[0].id)
        
        viewModel.updateData(matches)
        
        XCTAssertEqual(viewModel.fixtures.count, 1)

    }
}


class FixturesRepositoryMock: FixturesRepository{
    var result: Result<[Match], Error>?
    
    override func fetchFixtures(completion: @escaping (Result<[Match], Error>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}

class MockFetchFixturesUseCase: DefaultFetchFixturesUseCase {
    let mockData = [
        Match(id: 1, utcDate: Date(),
              status: .finished,
              homeTeam: Team(id: 1, name: "Arsenal", shortName: "Arsenal",
                             tla: "", crest: ""),
              awayTeam: Team(id: 2, name: "Manchester United", shortName: "MANU",
                             tla: "", crest: ""),
              score: Score(fullTime: Time(home: 2, away: 8),
                           halfTime: Time(home: nil, away: nil)), isFavorite: nil),
        Match(id: 1, utcDate: Date(),
              status: .finished,
              homeTeam: Team(id: 1, name: "Arsenal", shortName: "Arsenal",
                             tla: "", crest: ""),
              awayTeam: Team(id: 2, name: "Manchester United", shortName: "MANU",
                             tla: "", crest: ""),
              score: Score(fullTime: Time(home: 2, away: 8),
                           halfTime: Time(home: nil, away: nil)), isFavorite: nil),
        Match(id: 1, utcDate: Date(),
              status: .finished,
              homeTeam: Team(id: 1, name: "Arsenal", shortName: "Arsenal",
                             tla: "", crest: ""),
              awayTeam: Team(id: 2, name: "Manchester United", shortName: "MANU",
                             tla: "", crest: ""),
              score: Score(fullTime: Time(home: 2, away: 8),
                           halfTime: Time(home: nil, away: nil)), isFavorite: nil),
        Match(id: 1, utcDate: Date(),
              status: .finished,
              homeTeam: Team(id: 1, name: "Arsenal", shortName: "Arsenal",
                             tla: "", crest: ""),
              awayTeam: Team(id: 2, name: "Manchester United", shortName: "MANU",
                             tla: "", crest: ""),
              score: Score(fullTime: Time(home: 2, away: 8),
                           halfTime: Time(home: nil, away: nil)), isFavorite: nil)
    ]
    
    var result: Result<[Match], Error>!
    
    override func execute(completion: @escaping (Result<[Match], Error>) -> Void) {
        completion(result)
    }
}
