//
//  CommentModel.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/13/22.
//

import Foundation

struct CommentModel: Codable {
    
    let user: UserModel
    
    let comment: String
    
    let profilePicURL: URL?
    
    let date: Date
    
    /// Generating mock comments
    /// - Returns: array of comment models
    static func mockComments() -> [CommentModel] {
        
        let user = UserModel(username: "travisssss", profilePicURL: nil, identifier: UUID().uuidString)
        
        var array = [CommentModel]()
        
        let text = ["I like your style!"]
        
        for comment in text {
            
            array.append(CommentModel(user: user, comment: comment, profilePicURL: nil, date: Date()))
        }
        
        return array
    }
}
