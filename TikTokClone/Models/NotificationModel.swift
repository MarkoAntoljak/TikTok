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
    
    /// Mock data for notifications in activity tab
    /// - Returns: array of notification models
    static func mockData() -> [NotificationModel] {
        
        var array = [NotificationModel]()
        
        array.append(NotificationModel(text: "duaLipa has liked your post.", date: Date(), type: .postLike(postName: "myPost")))
        array.append(NotificationModel(text: "travisssss has commented on your post.", date: Date(), type: .postComment(postName: "myPost")))
        array.append(NotificationModel(text: "kimK has started following you.", date: Date(), type: .userFollow(username: "kimK")))
        
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


