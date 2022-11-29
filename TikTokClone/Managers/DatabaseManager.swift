//
//  DatabaseManager.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import Foundation
import FirebaseFirestore

/// Manager responsible for fetching and storing data in Cloud Firestore
struct DatabaseManager {
    
    // MARK: Attributes
    /// singleton
    public static let shared = DatabaseManager()
    /// database init
    private let database = Firestore.firestore()
    
    // MARK: Init
    
    private init() {}
    
    // MARK: Functions
    
    
    /// Getting the username of the current user who signs in
    /// - Parameters:
    ///   - email: email of the user
    ///   - completion: completion handler sends back string (username)
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
    
    
    /// Add user to the database
    /// - Parameters:
    ///   - username: username of the user
    ///   - email: email of the user
    ///   - password: passsword of the user
    ///   - completion: completion handler sends back boolean of success
    public func insertUser(username: String, email: String, completion: @escaping (Bool) -> Void) {
        
        // initial user data that goes into the database
        let userData: [String : Any] = [
            "username" : username,
            "email" : email,
            "followers" : [],
            "following" : []
        ]
        
        database.collection("users").document("\(username)").setData(userData) { error in
            
            completion(error == nil)
        }
        
    }
    
    
    /// Add video post to the database, with caption and string URL
    /// - Parameters:
    ///   - fileName: string URL file name of the video
    ///   - caption: caption of the video
    ///   - completion: completion handler that sends back boolean of success
    public func insertVideo(fileName: String, caption: String, completion: @escaping (Bool) -> Void) {
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        let data: [String: Any] = ["caption" : caption, "postURL" : fileName]
        
        database.collection("users").document("\(username.lowercased())").collection("posts").addDocument(data: data) { error in
            
            completion(error == nil)
        }
        
        
    }
    
    
    /// Fetching of notifications in activity tab
    /// - Parameter completion: completion handler that sends back array of notifications
    public func fetchNotifications(completion: @escaping ([NotificationModel]) -> Void) {
        
        // mock data of notificiations
        let notifications = NotificationModel.mockData()
        
        completion(notifications)
    }
    
    
    /// Removing notifications from database
    /// - Parameters:
    ///   - notificationID: notification identifier
    ///   - completion: completion handler sends back boolean of success
    public func removenotification(notificationID: String, completion: @escaping (Bool) -> Void) {
        
        completion(true)
    }
    
    
    /// Get all posted video posts from current user
    /// - Parameters:
    ///   - user: current user model
    ///   - completion: completion handler that sends back array of posts
    public func getPosts(user: UserModel, completion: @escaping ([PostModel]) -> Void) {
        
        // path in the database
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
            
            // get caption and postURL
            for document in snapshot.documents {
                
                let caption = document["caption"] as! String // it is forced cast because in the database
                let postURL = document["postURL"] as! String // it will always be a String
                
                var model = PostModel(identifier: UUID().uuidString, user: user)
                model.fileName = postURL
                model.caption = caption
                
                models.append(model)
            }
            
            completion(models)
        }
    }
    
    
    /// Get all followers and following users of the current user
    /// - Parameters:
    ///   - user: current user model
    ///   - type: type of follow (following or followers)
    ///   - completion: completion handler that sends back array of followers of following users
    public func getFollows(for user: UserModel, type: UserListViewController.ListType, completion: @escaping ([String]) -> Void) {
        
        // database path
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
            
            // if there are no followers or following users
            guard let document = snapshot.data() else {
                completion([])
                return
            }
            
            var follows = [String]()
            
            // names from all the users
            let followsName = document[type.rawValue] as! [String]
            
            follows.append(contentsOf: followsName)
            
            completion(follows)
            
        }
        
    }
    
    
    /// Checking to see if the user is current or other, this is used in order to display edit profile or follow/unfollow
    /// - Parameters:
    ///   - user: current user model
    ///   - type: type of follow (follower/following)
    ///   - completion: completion handler that sends back boolean of success
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
            
            // if there is no data
            guard let document = snapshot.data() else {
                completion(false)
                return
            }
            
            var follows = [String]()
            
            // getting all names
            let followsName = document[type.rawValue] as! [String]
            
            // make all names lowercased because of string comparison
            for name in followsName {
                
                follows.append(name.lowercased())
                
            }
            
            completion(follows.contains(username.lowercased()))
            
        }
    }
    
    
    /// Updating users follow/unfollow acitivity in the database
    /// - Parameters:
    ///   - user: current user model
    ///   - follow: followed or unfollowed
    ///   - completion: completion handler that sens back boolean of success
    public func updateRelationship(for user: UserModel, follow: Bool, completion: @escaping (Bool) -> Void) {
        
        guard let currentUsername = UserDefaults.standard.string(forKey: "username")?.lowercased() else {return}
        
        let path = self.database.collection("users").document(currentUsername)
        let path2 = self.database.collection("users").document(user.username.lowercased())
        
        if follow {
            // follow
            
            /// insert into current user's following
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
                    
                    path.updateData([
                        "following" : followingNames
                    ]) { error in
                        completion(error == nil)
                    }
                    
                } else {
                    
                    path.updateData([
                        "following" : [usernameToInsert]
                    ]) { error in
                        completion(error == nil)
                    }
                }
                
            }
            
            /// insert into target users followers
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
                    
                    path2.updateData([
                        "followers" : followingNames
                    ]) { error in
                        completion(error == nil)
                    }
                    
                } else {
                    
                    path2.updateData([
                        "followers" : [usernameToInsert]
                    ]) { error in
                        completion(error == nil)
                    }
                }
                
            }
            
            
        } else {
            // unfollow
            
            /// remove from current user's following
            path.getDocument { snapshot, error in
                
                let usernameToRemove = user.username.lowercased()
                
                if let error = error {
                    print(error)
                    return
                }
                
                guard let snapshot = snapshot else {return}
                
                guard let documentData = snapshot.data() else {return}
                
                if var followingNames = documentData["following"] as? [String] {
                    
                    followingNames.removeAll(where: {$0.lowercased() == usernameToRemove.lowercased()})
                    
                    path.updateData([
                        "following" : followingNames
                    ]) { error in
                        completion(error == nil)
                    }
                    
                    
                }
            }
            
            /// remove from target users followers
            path2.getDocument { snapshot, error in
                
                let usernameToRemove = currentUsername
                
                if let error = error {
                    print(error)
                    return
                }
                
                guard let snapshot = snapshot else {return}
                
                guard let documentData = snapshot.data() else {return}
                
                if var followingNames = documentData["followers"] as? [String] {
                    
                    followingNames.removeAll(where: {$0.lowercased() == usernameToRemove.lowercased()})
                    
                    path2.updateData([
                        "followers" : followingNames
                    ]) { error in
                        completion(error == nil)
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
