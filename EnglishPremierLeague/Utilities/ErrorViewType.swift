//
//  ErrorViewType.swift
//  EnglishPremierLeague
//
//  Created by Amr Khafaga [Pharma] on 06/03/2023.
//

import Foundation

enum ErrorViewType: Error {
    case technicalError
    case connectionError
    
    case noError
    
    var title: String {
        switch self {
        case .technicalError:
            return "Something went wrong."
        case .connectionError:
            return "Internet Connection unstable."
        case .noError : return ""
        }
    }
    
    var subtitle: String {
        switch self {
        case .technicalError:
            return "Reload the page to view the content and continue using the app."
        case .connectionError:
            return "Check your internet connection to continue using the app."
        case .noError : return ""
        }
    }
    
    var image: String {
        switch self {
        case .technicalError:
            return "error"
        case .connectionError:
            return "no-connection"
        case .noError : return ""
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .technicalError:
            return "Reload"
        case .connectionError:
            return "Retry"
        case .noError : return ""
        }
    }
}
