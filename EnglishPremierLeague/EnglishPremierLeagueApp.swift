//
//  EnglishPremierLeagueApp.swift
//  EnglishPremierLeague
//
//  Created by Amr Khafaga [Pharma] on 05/03/2023.
//

import SwiftUI
import Moya

@main
struct EnglishPremierLeagueApp: App {
    let provider: MoyaProvider<FixturesAPI>
    let fixturesRepository: FixturesRepository
    let fixturesViewModel: FixturesViewModel
    
    init() {
        self.provider = MoyaProvider<FixturesAPI>()
        self.fixturesRepository = FixturesRepository(provider: provider)
        self.fixturesViewModel = FixturesViewModel(
            fixturesUseCase: DefaultFetchFixturesUseCase(fixturesRepository: self.fixturesRepository))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: self.fixturesViewModel)
        }
    }
}
