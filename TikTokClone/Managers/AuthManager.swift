//
//  AuthManager.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import Foundation
import FirebaseAuth


/// Manager responsible for User Authentication
class AuthManager {
    
    // MARK: Attributes
    
    /// singleton
    public static let shared = AuthManager()
    /// auth init
    private let auth = Auth.auth()
    
    private init() {}
    
    /// computed property that checks if current user is already logged in
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    // MARK: Functions
    
    /// Signing in the user
    /// - Parameters:
    ///   - email: email of the user
    ///   - password: password of the user
    ///   - completion: completion handler sends back the email or error
    public func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        auth.signIn(withEmail: email, password: password) { result, error in
            
            guard result != nil, error == nil else {
    
                if let error = error {completion(.failure(error))} else { return }
                
                return
            }
            
            completion(.success(email))

        }
        
    }
    
    
    /// Registering the user in the database
    /// - Parameters:
    ///   - username: username of the user
    ///   - email: email of the user
    ///   - password: password of the user
    ///   - completion: completion handler sends back boolean of success
    public func signUp(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        auth.createUser(withEmail: email, password: password) { result, error in
            
            guard result != nil, error == nil else {
                
                print("Error: Cannot register the user.")
                completion(false)
                return
            }
            
            // add user to database
            DatabaseManager.shared.insertUser(username: username, email: email, password: password) { success in
                
                completion(success == true)
                
            }
        }
        
    }
    
    
    /// Signing out the user
    /// - Parameter completion: completion handler sends back boolean of success
    public func signOut(completion: @escaping (Bool) -> Void) {
        
        do {
            
            try auth.signOut()
            completion(true)
            
        } catch {
            
            print(error.localizedDescription)
            completion(false)
        }
        
    }
    
}
