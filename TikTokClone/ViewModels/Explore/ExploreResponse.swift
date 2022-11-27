//
//  ExploreResponse.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/27/22.
//

import Foundation


struct ExploreResponse: Codable {
    
    let featured: [FeaturedModel]
    
    let creators: [CreatorModel]
    
    let hashtags: [HashtagModel]
    
    let recommended: [CreatorModel]
    
    let recent: [FeaturedModel]
    
}
