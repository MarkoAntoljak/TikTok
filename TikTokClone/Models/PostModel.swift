//
//  PostModel.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import Foundation

struct PostModel {
    
    let identifier: String
    
    var isLikedByCurrentUser: Bool = false
    
    static func mockModels() -> [PostModel] {
        
        var posts = [PostModel]()
        
        for _ in 0...100 {
            let post = PostModel(identifier: UUID().uuidString)
            posts.append(post)
        }
        
        return posts
    }
}