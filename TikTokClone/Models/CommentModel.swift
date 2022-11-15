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
    
    static func mockComments() -> [CommentModel] {
        
        let user = UserModel(username: "markoant123", profilePicURL: nil, identifier: UUID().uuidString)
        
        var array = [CommentModel]()
        
        let text = ["Good", "Great", "Awesome","Gud", "Gid", "Alright"]
        
        for comment in text {
            
            array.append(CommentModel(user: user, comment: comment, profilePicURL: nil, date: Date()))
        }
        
        return array
    }
}
