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
        
        database.collection("users").document("\(username)").setData(userData)
        
        completion(true)
    }
    
    public func getAllUsers(completion: @escaping ([String]) -> Void) {
        
        
        
    }

    
    
}
