//
//  ExploreViewModel.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/14/22.
//

import Foundation
import UIKit

struct ExplorePostViewModel {
    
    let caption: String?
    
    let image: UIImage?
    
    let handler: (() -> Void)
}

struct ExploreUserViewModel {
    
    let profilePicURL: URL?
    
    let username: String
    
    let followerCount: Int
    
    let handler: (() -> Void)
}

struct ExploreHashtagViewModel {
    
    let text: String
    
    let icon: UIImage?
    
    let count: Int // how many users used this hashtag
    
    let handler: (() -> Void)
}

struct ExploreFeaturedViewModel {
    
    let image: UIImage?
    
    let title: String
    
    let handler: (() -> Void)
}
