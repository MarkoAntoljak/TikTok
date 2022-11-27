//
//  PostModel.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import Foundation


struct PostModel {
    
    let identifier: String
    
    let user: UserModel
    
    var caption: String = ""
    
    var fileName: String = ""
    
    var isLikedByCurrentUser: Bool = false
    
    /// Mock data for posted posts
    /// - Returns: array of post models
    static func mockModels() -> [PostModel] {
        
        var posts = [PostModel]()
        
        for _ in 0...100 {
            let post = PostModel(identifier: "1234", user: UserModel(username: "kanyeWest", profilePicURL: nil, identifier: UUID().uuidString))
            posts.append(post)
        }
        
        return posts
    }
    
    /// Path of the post video URL, based on the current user
    var videoURLPath: String {
        
        return "videos/\(user.username)/\(fileName)"
    }
    
}
