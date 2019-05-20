//
//  MediaType.swift
//  iTunesSearch
//
//  Created by Brian Sipple on 5/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

enum MediaType {
    case book
    case podcast
    case music
    case app
    case all
}


// MARK: - Computed Properties

extension MediaType {
    
    var queryParamValue: String {
        switch self {
        case .book:
            return "ebook"
        case .podcast:
            return "podcast"
        case .music:
            return "music"
        case .app:
            return "software"
        case .all:
            return "all"
        }
    }
    
    
    var searchScopeTitle: String {
        switch self {
        case .book:
            return "Books"
        case .podcast:
            return "Podcasts"
        case .app:
            return "Apps"
        case .music:
            return "Music"
        case .all:
            return "All"
        }
    }
}
