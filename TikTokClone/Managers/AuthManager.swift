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
    
    enum SignInMethod {
        
        case facebook
        case google
        case email
        
    }
    
    // MARK: Functions
    
    // Signing in the user
    public func signIn(with method: SignInMethod) {}
    
    // Registering / Signing Up the user
    public func signUp() {}
    
}
