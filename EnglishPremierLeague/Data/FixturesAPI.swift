//
//  FixturesAPI.swift
//  EnglishPremierLeague
//
//  Created by Amr Khafaga [Pharma] on 05/03/2023.
//

import Foundation
import Moya

enum FixturesAPI {
    case fixtures
}

extension FixturesAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.football-data.org/v4")!
    }
    
    var path: String {
        switch self {
        case .fixtures:
            return "/competitions/PL/matches"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fixtures:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fixtures:
            return .requestParameters(parameters: ["dateFrom": Date().toString(), "dateTo": "2023-05-28"],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        if let storedApiKey = KeychainManager.getApiKey() {
            return ["X-Auth-Token": storedApiKey]
        }
        
        return nil
    }
}
