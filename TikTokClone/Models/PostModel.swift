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
    
    static func mockModels() -> [PostModel] {
        
        var posts = [PostModel]()
        
        for _ in 0...100 {
            let post = PostModel(identifier: "noUser", user: UserModel(username: "user", profilePicURL: nil, identifier: "NoUser"))
            posts.append(post)
        }
        
        return posts
    }
    
    var videoURLPath: String {
        
        return "videos/\(user.username)/\(fileName)"
    }
}
