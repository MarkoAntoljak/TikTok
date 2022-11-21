//
//  DatabaseManager.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    
    // MARK: Attributes
    
    public static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    
    // MARK: Init

    private init() {}
    
    // MARK: Functions
    
    // add user to the database
    public func insertUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        let userData: [String : Any] = [
            "username" : username,
            "email" : email,
            "password" : password
        ]
        
        database.collection("users").document("\(username)").setData(userData) { error in
            
            completion(error == nil)
        }
        
    }
    
    public func insertVideo(fileName: String, caption: String, completion: @escaping (Bool) -> Void) {
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
        
        let currentDate = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
        
        let postData: [String: Any] = [
            "postURL" : fileName,
            "caption" : caption
        ]
        
        database.collection("users").document("\(username)").collection("posts").document(currentDate).setData(postData) { error in
            
            completion(error == nil)
        }
        
        
    }
    
    public func fetchNotifications(completion: @escaping ([NotificationModel]) -> Void) {
        
        let notifications = NotificationModel.mockData()
        
        completion(notifications)
    }
    
    public func removenotification(notificationID: String, completion: @escaping (Bool) -> Void) {
        
        completion(true)
    }
    
    public func follow(username: String, completion: @escaping (Bool) -> Void) {
     
        completion(true)
    }
    
    public func getAllUsers(completion: @escaping ([String]) -> Void) {
        
        
        
    }

    
    
}
