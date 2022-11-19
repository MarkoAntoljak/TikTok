//
//  AuthManager.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    
    // MARK: Attributes
    
    public static let shared = AuthManager()
    
    private let auth = Auth.auth()
    
    private init() {}
    
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    enum SignInMethod {
        
        case facebook
        case google
        case email
        
    }
    
    // MARK: Functions
    
    // Signing in the user
    public func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        auth.signIn(withEmail: email, password: password) { result, error in
            
            guard result != nil, error == nil else {
    
                if let error = error {completion(.failure(error))} else { return }
                
                return
            }
            
            completion(.success(email))

        }
        
    }
    
    // Registering / Signing Up the user
    public func signUp(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        auth.createUser(withEmail: email, password: password) { result, error in
            
            guard result != nil, error == nil else {
                print("cannot auth sign up")
                completion(false)
                return
            }
            
            // add user to database
            DatabaseManager.shared.insertUser(username: username, email: email, password: password) { success in
                
                if success {
                    print("success to database")
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
        
    }
    
    // signing out the user
    public func signOut(completion: @escaping (Bool) -> Void) {
        
        do {
            
            try Auth.auth().signOut()
            
            completion(true)
        } catch {
            print(error)
            print("Cannot Sign Out the user")
            completion(false)
        }
        
    }
    
}
