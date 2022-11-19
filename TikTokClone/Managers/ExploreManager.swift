//
//  ExploreManager.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/15/22.
//

import Foundation
import UIKit

protocol ExploreManagerDelegate: AnyObject {
    
    func pushViewController(vc: UIViewController)
    
}

final class ExploreManager {
    
    // MARK: Attributes
    
    static let shared = ExploreManager()
    
    weak var delegate: ExploreManagerDelegate?
    
    // MARK: Functions
    
    // getting data from json format for each section
    
    // featured
    public func getExploreFeatured() -> [ExploreFeaturedViewModel] {
        
        guard let exploreData = parseJSON() else {return []}
        
        return exploreData.featured.compactMap { model in
            ExploreFeaturedViewModel(image: UIImage(named: model.image), caption: model.caption) {
                // empty
            }
        }
        
    }
    
    // creators
    public func getExploreCreators() -> [ExploreUserViewModel] {
        
        guard let exploreData = parseJSON() else {return []}
        
        return exploreData.creators.compactMap {
            ExploreUserViewModel(profilePic: UIImage(named: $0.profilePicture), username: $0.username, followerCount: $0.followerCount) {
                //empty
            }
        }
        
    }
    
    // hashtag
    public func getExploreHashtags() -> [ExploreHashtagViewModel] {
        
        guard let exploreData = parseJSON() else {return []}
        
        return exploreData.hashtags.compactMap {
            ExploreHashtagViewModel(text: $0.text, icon: UIImage(systemName: "number.square.fill"), count: $0.count) {
                //empty
            }
        }
        
    }
    
    // recommended
    public func getExploreRecommended() -> [ExploreUserViewModel] {
        
        guard let exploreData = parseJSON() else {return []}
        
        return exploreData.recommended.compactMap {
            ExploreUserViewModel(profilePic: UIImage(named: $0.profilePicture), username: $0.username, followerCount: $0.followerCount) {
                //empty
            }
        }
        
    }
    
    // recent
    public func getExploreRecent() -> [ExploreFeaturedViewModel] {
        
        guard let exploreData = parseJSON() else {return []}
        
        return exploreData.recent.compactMap {
            ExploreFeaturedViewModel(image: UIImage(named: $0.image), caption: $0.caption) {
                //empty
            }
        }
        
    }
    

    // Parsing Data.JSON file
    private func parseJSON() -> ExploreResponse? {
            
        guard let path = Bundle.main.path(forResource: "Data", ofType: "json") else {
            print("Data.json not found")
            return nil
        }
        
        do {
            let url = URL(fileURLWithPath: path)
            
            let data = try Data(contentsOf: url)
            
            return try JSONDecoder().decode(ExploreResponse.self, from: data)
            
            
        } catch {
            print(error)
            return nil
        }
    }
    
    
}


struct ExploreResponse: Codable {
    
    let featured: [FeaturedModel]
    
    let creators: [UserExploreModel]
    
    let hashtags: [HashtagModel]
    
    let recommended: [UserExploreModel]
    
    let recent: [FeaturedModel]
    
}

struct FeaturedModel: Codable {
 
    let id: String
    let caption: String
    let image: String
    let action: String
    
}

struct UserExploreModel: Codable {
 
    let id: String
    let profilePicture: String
    let username: String
    let followerCount: Int
    
}

struct HashtagModel: Codable {
 
    let id: String
    let text: String
    let count: Int
    
}


