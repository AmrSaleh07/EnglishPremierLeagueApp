//
//  ContentView.swift
//  EnglishPremierLeague
//
//  Created by Amr Khafaga [Pharma] on 05/03/2023.
//

import SwiftUI
import Moya

struct FixturesView: View {
    @StateObject var viewModel: FixturesViewModel
    
    init(viewModel: FixturesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    var body: some View {
        switch viewModel.state {
        case .loading:
            LoadingView()
                .onAppear {
                    viewModel.didLoad.send()
                }
        case .loaded:
            NavigationView {
                List {
                    let sections = viewModel.sectionedFixtures()
                    if sections.isEmpty {
                        NoFavoritesView()
                    } else {
                        ForEach(sections) { section in
                            Section(section.title) {
                                ForEach(section.matches) { match in
                                    MatchRowView(match: match) {
                                        viewModel.didTapOnAddToFavorites.send(match)
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(.grouped)
                .toolbar {
                    HStack(spacing: 4) {
                        Text("Favorites only")
                        Toggle("", isOn: $viewModel.isShowingFavoritesOnly)
                            .toggleStyle(SwitchToggleStyle(tint: Color.purple))
                            .labelsHidden()
                    }
                }
                .refreshable {
                    viewModel.didPullToRefresh.send()
                }
            }
            
        case .error(let error):
            ErrorView(type: error) {
                viewModel.didTapOnRetry.send()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FixturesView(viewModel: FixturesViewModel(
            fixturesUseCase:
                DefaultFetchFixturesUseCase(
                    fixturesRepository:
                        FixturesRepository(
                            provider: MoyaProvider<FixturesAPI>())
                )))
    }
}
