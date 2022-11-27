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
    
    
    public func uploadProfilePicture(image: UIImage, completion: @escaping (Result<URL,Error>) -> Void) {
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
        
        guard let imageData = image.pngData() else {return}
        
        let path = "profilePhotos/\(username)/profilePicture.png"
        
        storage.child(path).putData(imageData) { result, error in
        
            if result != nil {
                
                self.storage.child(path).downloadURL { url, error in
                    
                    guard let url = url else {
                        
                        if let error = error {
                            print("error while unwraping url")
                            completion(.failure(error))
                        }
                        
                        return
                    }
                    
                    completion(.success(url))
                    
                }
            } else {
                
                print("cannot upload image data to storage")
                
                if let error = error {
                    completion(.failure(error))
                }
            }
            
        }
        
    }
    
    func getVideoDownloadURL(for post: PostModel, completion: @escaping (Result<URL, Error>) -> Void) {
        
        storage.child(post.videoURLPath).downloadURL { resultUrl, error in
            
            
            if let url = resultUrl {
                
                completion(.success(url))
                print(url)
                
            } else if let error = error {
                
                completion(.failure(error))
            }
            
        }
    }
    
}
