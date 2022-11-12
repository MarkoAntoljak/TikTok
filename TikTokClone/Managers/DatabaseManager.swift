//
//  DatabaseManager.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    public static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    private init() {}
    
    // MARK: Functions
    
    public func getAllUsers(completion: @escaping ([String]) -> Void) {
        
        
        
    }

    
    
}
