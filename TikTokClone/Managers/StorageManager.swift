//
//  StorageManager.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import Foundation
import FirebaseStorage


/// Manager responsible for stroing and fetching data in Firebase Storage
struct StorageManager {
    
    // MARK: Attributes
    /// singleton
    public static let shared = StorageManager()
    /// object init
    private let storage = Storage.storage().reference()
    
    private init() {}
    
    // MARK: Functions
    
    
    /// Uploading video to storage
    /// - Parameters:
    ///   - url: video post url
    ///   - fileName: video post file name
    ///   - caption: caption of the video post
    ///   - completion: completion handler that sends back boolean of success
    public func uploadVideoURL(from url: URL, fileName: String, caption: String, completion: @escaping (Bool) -> Void) {
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
        
        storage.child("videos/\(username)/\(fileName)").putFile(from: url) { _, error in
            
            completion(error == nil)
            
        }
    }
    
    
    /// Generating random video name
    /// - Returns: random generated video name based on specific id, username and current date
    public func generateVideoName() -> String {
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {return ""}
        
        let uuidString = UUID().uuidString
        let timePosted = Date()
        
        return "\(uuidString)_\(username)_\(timePosted).mp4"
        
    }
    
    
    /// Uploading profile picture to storage
    /// - Parameters:
    ///   - image: profile picture image
    ///   - completion: completion handler that sends back url or error
    public func uploadProfilePicture(image: UIImage, completion: @escaping (Result<URL,Error>) -> Void) {
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
        
        guard let imageData = image.pngData() else {return}
        
        let path = "profilePhotos/\(username)/profilePicture.png"
        
        storage.child(path).putData(imageData) { result, error in
        
            if result != nil {
                
                self.storage.child(path).downloadURL { url, error in
                    
                    guard let url = url else {
                        
                        if let error = error {

                            completion(.failure(error))
                        }
                        
                        return
                    }
                    
                    completion(.success(url))
                    
                }
            } else {
                
                print("Error: Cannot upload image to storage.")
                
                if let error = error {
                    
                    completion(.failure(error))
                    
                }
            }
            
        }
        
    }
    
    
    /// Download video post url from storage
    /// - Parameters:
    ///   - post: video post model
    ///   - completion: completion handler that sends back url or error
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
