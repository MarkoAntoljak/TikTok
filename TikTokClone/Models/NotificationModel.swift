//
//  NotificationModel.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/20/22.
//

import Foundation

class NotificationModel {
    
    var identifier = UUID().uuidString
    
    var isHidden = false
    
    let text: String
    
    let date: Date
    
    let type: NotificationType
    
    init(text: String, date: Date, type: NotificationType) {
    
        self.text = text
        self.date = date
        self.type = type
    }
    
    static func mockData() -> [NotificationModel] {
        
        var array = [NotificationModel]()
        
        for _ in 0...20 {
            array.append(NotificationModel(text: "Like", date: Date(), type: .postLike(postName: "idk")))
            array.append(NotificationModel(text: "Comment", date: Date(), type: .postComment(postName: "idk")))
            array.append(NotificationModel(text: "Follow", date: Date(), type: .userFollow(username: "tomis321")))
        }
        
        return array
    }
    
}

enum NotificationType {
    
    case postLike(postName: String)
    
    case postComment(postName: String)
    
    case userFollow(username: String)
    
    var id: String {
        
        switch self {
            
        case .postComment:  return "Post Comment"
            
        case .postLike:  return "Post Like"
            
        case .userFollow: return "User Follow"
            
        }
    }
}


