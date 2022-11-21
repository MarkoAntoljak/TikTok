//
//  StorageManager.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    public static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    private init() {}
    
    // MARK: Functions
    
    // downloading videos from storage
    public func downloadVideoURL(with identifier: String, completion: @escaping (URL) -> Void) {
        
        
    }

    
    // uploading videos to storage
    public func uploadVideoURL(from url: URL, fileName: String, caption: String, completion: @escaping (Bool) -> Void) {
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
    
        storage.child("videos/\(username)/\(fileName)").putFile(from: url) { _, error in
            
            completion(error == nil)
            
        }
    }
    
    public func generateVideoName() -> String {
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {return ""}
        
        let uuidString = UUID().uuidString
        let timePosted = Date()
        
        return "\(uuidString)_\(username)_\(timePosted).mp4"
        
    }
    
}
