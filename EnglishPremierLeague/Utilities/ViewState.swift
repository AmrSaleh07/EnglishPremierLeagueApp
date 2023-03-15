//
//  ViewState.swift
//  EnglishPremierLeague
//
//  Created by Amr Khafaga [Pharma] on 07/03/2023.
//

import Foundation

enum ViewState: Equatable {
    case loading
    case loaded
    case error(ErrorViewType)
}
