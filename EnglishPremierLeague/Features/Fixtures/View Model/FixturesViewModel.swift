//
//  FixturesViewModel.swift
//  EnglishPremierLeague
//
//  Created by Amr Khafaga [Pharma] on 05/03/2023.
//

import Foundation
import Combine

class FixturesViewModel: ObservableObject {
    
    // MARK: - Inputs
    let didTapOnAddToFavorites = PassthroughSubject<FixtureModel, Never>()
    let didPullToRefresh = PassthroughSubject<Void, Never>()
    let didLoad = PassthroughSubject<Void, Never>()
    let didTapOnRetry = PassthroughSubject<Void, Never>()
    
    // MARK: - Outputs
    @Published var errorType: ErrorViewType = .noError
    @Published var state: ViewState = .loading
    @Published var fixtures: [Date: [FixtureModel]] = [:]
    @Published var favoriteMatches: Set<Int> = (UserDefaultsManager.favoriteMatchesIds ?? [])
    @Published var isShowingFavoritesOnly = false
    
    // MARK: - Internal Properties
    private var subscriptions = Set<AnyCancellable>()
    @Published var monitor = NetworkMonitor()
    private let fixturesUseCase: DefaultFetchFixturesUseCase
    
    init(fixturesUseCase: DefaultFetchFixturesUseCase) {
        self.fixturesUseCase = fixturesUseCase
        self.setupBindings()
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    private func setupBindings() {
        
        didLoad
            .sink { [weak self] in
                guard let self = self else { return }
                self.state = .loading
                self.fetchFixtures()
            }
            .store(in: &subscriptions)
        
        didTapOnAddToFavorites
            .sink { [weak self] in
                guard let self = self else { return }
                self.toggleFavorite(for: $0)
            }
            .store(in: &subscriptions)

        didPullToRefresh
            .sink { [weak self] in
                guard let self = self else { return }
                self.fetchFixtures()
            }
            .store(in: &subscriptions)
        
        didTapOnRetry
            .sink { [weak self] in
                guard let self = self else { return }
                self.didLoad.send()
            }
            .store(in: &subscriptions)
    }
    
    private func fetchFixtures() {
        fixturesUseCase.execute { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(matches):
                self.state = .loaded
                self.updateData(matches)
            case .failure:
                self.handleError()
            }
        }
    }
    
    private func createFixturesVMs(_ matches: [Match]) -> [FixtureModel] {
        return matches.map { FixtureModel(match: $0) }
    }
    
    // This private function is used to toggle the favorite state of a match.
    // It takes a FixtureViewModel object as a parameter.
    // If the match's id is already present in the favoriteMatches set, it removes it. Otherwise, it adds it.
    // It also toggles the isFavorite flag of the match.
    // Finally, it saves the updated favoriteMatches set to the user defaults using the UserDefaultsManager helper class.
    private func toggleFavorite(for match: FixtureModel) {
        if favoriteMatches.contains(match.id) {
            favoriteMatches.remove(match.id)
        } else {
            favoriteMatches.insert(match.id)
        }
        
        match.isFavorite.toggle()
       
        UserDefaultsManager.favoriteMatchesIds = self.favoriteMatches
    }
    
    // This private function is used to update the fixtures data with new matches.
    // It takes an array of Match objects as a parameter.
    // It first creates an array of FixtureViewModels using the "createFixturesVMs" function.
    // It then creates a dictionary of fixtures grouped by date.
    // For each match, it retrieves the corresponding date by creating a new Date object from the match's UTC date.
    // It then adds the match to the corresponding date's array of matches in the groupedMatches dictionary.
    // If the match is a favorite, it sets the isFavorite flag to true.
    // Finally, it sets the fixtures property to the groupedMatches dictionary.
    private func updateData(_ matches: [Match]) {
        let matchesVMs = self.createFixturesVMs(matches)
        var groupedMatches = [Date: [FixtureModel]]()
        for match in matchesVMs {
            if let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: match.utcDate)) {
                var matchesForDate = groupedMatches[date] ?? []
                if favoriteMatches.contains(match.id) {
                    match.isFavorite = true
                }
                matchesForDate.append(match)
                groupedMatches[date] = matchesForDate
            }
        }
        
        fixtures = groupedMatches
    }
    
    // This function returns an array of SectionedFixtures, which is created by grouping the fixtures by their dates.
    // It first creates an empty array of SectionedFixtures.
    // Then it sorts the fixtures' keys in ascending order, and iterates through them.
    // For each date, it retrieves the corresponding fixtures from the fixtures dictionary.
    // If the "isShowingFavoritesOnly" flag is set, it filters the fixtures to show only the favorite matches.
    // It then creates a SectionedFixtures object using the "createSectionTitle" function to get the section title and the filtered fixtures.
    // If there are no matches for the section, it will not be added to the sectionedFixtures array.
    // Finally, the function returns the sectionedFixtures array.
    func sectionedFixtures() -> [SectionedFixtures] {
        var sectionedFixtures = [SectionedFixtures]()
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let sortedDates = fixtures.keys.sorted { calendar.compare($0, to: $1, toGranularity: .day) == .orderedAscending }
        for date in sortedDates {
            let matchesForDate = fixtures[date] ?? []
            var filteredMatches = matchesForDate
            if isShowingFavoritesOnly {
                filteredMatches = matchesForDate.filter { favoriteMatches.contains($0.id) }
            }
            let sectionedFixture = SectionedFixtures(title: createSectionTitle(matchDate: date),
                                                     matches: filteredMatches)
            if !sectionedFixture.matches.isEmpty {
                sectionedFixtures.append(sectionedFixture)
            }
        }
        return sectionedFixtures
    }
    
    // This private function is used to create a section title for a match date.
    // It takes a Date object as a parameter and returns a string.
    // If the match is today, the section title is set to "Today".
    // If the match is tomorrow, the section title is set to "Tomorrow".
    // Otherwise, it sets the section title to a formatted date string using the "EEEE, MMMM d" format.
    
    private func createSectionTitle(matchDate: Date) -> String {
        var sectionTitle = ""

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        if matchDate.isToday() {
            sectionTitle = "Today"
        } else if matchDate.isTomorrow() {
            sectionTitle = "Tomorrow"
        } else {
            sectionTitle = dateFormatter.string(from: matchDate)
        }
        return sectionTitle
    }
    
    // This private function sets the state of the object based on the type of error that occurred.
    // If the monitor object is not connected, the error type is set to connectionError.
    // If the monitor object is connected, the error type is set to technicalError.
    // Finally, it sets the state of the object to error with the determined error type.
    private func handleError() {
        if !monitor.isConnected {
            errorType = .connectionError
        } else {
            errorType = .technicalError
        }
        self.state = .error(errorType)
    }
}


