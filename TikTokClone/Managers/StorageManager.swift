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
    public func uploadVideoURL(from url: URL) {
        
        
        
    }
    
}
