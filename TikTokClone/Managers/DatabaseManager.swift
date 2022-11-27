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
    
    // getting username of user who signs in
    public func getUsername(email: String, completion: @escaping (String) -> Void) {
        
        database.collection("users").getDocuments { snapshot, error in
            
            // if there is no user uploaded yet
            guard let snapshot = snapshot else {
                completion("")
                return
            }
            
            for document in snapshot.documents {
                
                let emailString = document["email"] as! String
                
                if emailString.lowercased() == email.lowercased() {
                    
                    let userName = document["username"] as! String
                    
                    completion(userName)
                    
                }
            }
            
            
        }
    }
    
    // add user to the database
    public func insertUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        let userData: [String : Any] = [
            "username" : username,
            "email" : email,
            "password" : password,
            "followers" : [],
            "following" : []
        ]
        
        database.collection("users").document("\(username)").setData(userData) { error in
            
            completion(error == nil)
        }
        
    }
    
    // add post to the database
    public func insertVideo(fileName: String, caption: String, completion: @escaping (Bool) -> Void) {
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        let data: [String: Any] = ["caption" : caption, "postURL" : fileName]
        
        database.collection("users").document("\(username.lowercased())").collection("posts").addDocument(data: data)
        
        
    }
    
    // fetch activity notifiactions
    public func fetchNotifications(completion: @escaping ([NotificationModel]) -> Void) {
        
        let notifications = NotificationModel.mockData()
        
        completion(notifications)
    }
    
    // remove on slide notifications
    public func removenotification(notificationID: String, completion: @escaping (Bool) -> Void) {
        
        completion(true)
    }
    
    // following reflect on database
    public func follow(username: String, completion: @escaping (Bool) -> Void) {
        
        completion(true)
    }
    
    // getting all posts from user
    public func getPosts(user: UserModel, completion: @escaping ([PostModel]) -> Void) {
        
        
        let path = database.collection("users").document("\(user.username.lowercased())").collection("posts")
        
        path.getDocuments { snapshot, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            // if there is no post uploaded yet
            guard let snapshot = snapshot else {
                completion([])
                return
            }
            
            var models: [PostModel] = []
            
            for document in snapshot.documents {
                
                let caption = document["caption"] as! String
                let postURL = document["postURL"] as! String
                
                var model = PostModel(identifier: UUID().uuidString, user: user)
                model.fileName = postURL
                model.caption = caption
                
                models.append(model)
            }
            
            
            completion(models)
        }
    }
    
    // get all followers/ following
    public func getFollows(for user: UserModel, type: UserListViewController.ListType, completion: @escaping ([String]) -> Void) {
        
        let path = database.collection("users").document(user.username.lowercased())
        
        path.getDocument { snapshot, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {
                print(error!.localizedDescription)
                return
            }
            
            guard let document = snapshot.data() else {
                completion([])
                return
            }
            
            var follows = [String]()
            
            let followsName = document[type.rawValue] as! [String]
            
            follows.append(contentsOf: followsName)
            
            completion(follows)
            
        }
        
    }
    
    // check to see if it is current user of else
    public func isValidRelationship(for user: UserModel, type: UserListViewController.ListType, completion: @escaping (Bool) -> Void) {
        
        let path = database.collection("users").document(user.username.lowercased())
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
        
        path.getDocument { snapshot, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {
                print(error!.localizedDescription)
                return
            }
            
            guard let document = snapshot.data() else {
                completion(false)
                return
            }
            
            var follows = [String]()
            
            let followsName = document[type.rawValue] as! [String]
            
            // make all names lowercased because of string comparison
            for name in followsName {
                
                follows.append(name.lowercased())
                
            }
            
            completion(follows.contains(username.lowercased()))
            
        }
    }
    
    // unfollow/follow database tracking
    public func updateRelationship(for user: UserModel, follow: Bool, completion: @escaping (Bool) -> Void) {
        
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {return}
        
        let path = database.collection("users").document(currentUsername.lowercased())
        let path2 = database.collection("users").document(user.username.lowercased())
        
        if follow {
            // follow
            
            // insert into current user's following
            path.getDocument { snapshot, error in
                
                let usernameToInsert = user.username.lowercased()
                
                if let error = error {
                    print(error)
                    return
                }
                
                guard let snapshot = snapshot else {return}
                
                guard let documentData = snapshot.data() else {return}
                
                if var followingNames = documentData["following"] as? [String] {
                    
                    followingNames.append(usernameToInsert)
                    
                    path.setData([
                        "following" : followingNames
                    ]) { error in
                        completion(error == nil)
                    }
                    
                } else {
                    
                    path.setData([
                        "following" : [usernameToInsert]
                    ]) { error in
                        completion(error == nil)
                    }
                }
                
            }
            
            // insert into target users followers
            path2.getDocument { snapshot, error in
                
                let usernameToInsert = currentUsername
                
                if let error = error {
                    print(error)
                    return
                }
                
                guard let snapshot = snapshot else {return}
                
                guard let documentData = snapshot.data() else {return}
                
                if var followingNames = documentData["followers"] as? [String] {
                    
                    followingNames.append(usernameToInsert)
                    
                    path2.setData([
                        "followers" : followingNames
                    ]) { error in
                        completion(error == nil)
                    }
                    
                } else {
                    
                    path2.setData([
                        "followers" : [usernameToInsert]
                    ]) { error in
                        completion(error == nil)
                    }
                }
                
            }
            
            
        } else {
            // unfollow
            
            // remove from current user following
            path.getDocument { snapshot, error in
                
                let usernameToRemove = user.username.lowercased()
                
                if let error = error {
                    print(error)
                    return
                }
                
                guard let snapshot = snapshot else {return}
                
                guard let documentData = snapshot.data() else {return}
                
                if var followingNames = documentData["following"] as? [String] {
                    
                    followingNames.removeAll(where: {$0 == usernameToRemove})
                    
                    path.setData([
                        "following" : followingNames
                    ]) { error in
                        completion(error == nil)
                    }
                    
                }
            }
            
            // remove from target users followers
            path2.getDocument { snapshot, error in
                
                let usernameToRemove = currentUsername
                
                if let error = error {
                    print(error)
                    return
                }
                
                guard let snapshot = snapshot else {return}
                
                guard let documentData = snapshot.data() else {return}
                
                if var followingNames = documentData["followers"] as? [String] {
                    
                    followingNames.removeAll(where: {$0 == usernameToRemove})
                    
                    path2.setData([
                        "followers" : followingNames
                    ]) { error in
                        completion(error == nil)
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
