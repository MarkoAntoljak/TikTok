//
//  ExploreSectionModel.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/14/22.
//

import Foundation


struct ExploreSectionModel {
    
    let type: ExploreSectionType
    
    let cells: [ExploreCell]
    
}

// explore sections for video posts
enum ExploreSectionType {
    
    case featured
    
    case creators
    
    case hashtags
    
    case recommended
    
    case recent
    
    var title: String {
        
        switch self {
            
        case .featured:
            return "Featured"
        case .creators:
            return "Creators"
        case .hashtags:
            return "Hashtags"
        case .recommended:
            return "Recommended"
        case .recent:
            return "Recent"
        }
    }
}

enum ExploreCell {
    
    case featured(viewModel: ExploreFeaturedViewModel)
    
    case hashtags(viewModel: ExploreHashtagViewModel)
    
    case post(viewModel: ExplorePostViewModel)
    
}
