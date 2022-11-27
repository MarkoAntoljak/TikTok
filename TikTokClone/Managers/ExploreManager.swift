//
//  ExploreManager.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/15/22.
//

import Foundation
import UIKit


/// Delegate for ExploreManager
protocol ExploreManagerDelegate: AnyObject {
    
    func pushViewController(vc: UIViewController)
    
}


/// Manager responsible for fetching explore sections data
/// fetching data from local Data.json file
final class ExploreManager {
    
    // MARK: Attributes
    /// singleton
    static let shared = ExploreManager()
    /// delegate
    weak var delegate: ExploreManagerDelegate?
    
    // MARK: Functions
    
    /// Get featured section data
    /// - Returns: array of featured view models
    public func getExploreFeatured() -> [ExploreFeaturedViewModel] {
        
        guard let exploreData = parseJSON() else {return []}
        
        return exploreData.featured.compactMap { model in
            
            ExploreFeaturedViewModel(image: UIImage(named: model.image), caption: model.caption) {}
            
        }
        
    }
    
    /// Get featured section data
    /// - Returns: array of creators view models
    public func getExploreCreators() -> [ExploreUserViewModel] {
        
        guard let exploreData = parseJSON() else {return []}
        
        return exploreData.creators.compactMap {
            
            ExploreUserViewModel(profilePic: UIImage(named: $0.profilePicture), username: $0.username, followerCount: $0.followerCount) {}
            
        }
        
    }
    
    /// Get featured section data
    /// - Returns: array of hashtags view models
    public func getExploreHashtags() -> [ExploreHashtagViewModel] {
        
        guard let exploreData = parseJSON() else {return []}
        
        return exploreData.hashtags.compactMap {
            
            ExploreHashtagViewModel(text: $0.text, icon: UIImage(systemName: "number.square.fill"), count: $0.count) {}
        }
        
    }
    
    /// Get featured section data
    /// - Returns: array of recommended view models
    public func getExploreRecommended() -> [ExploreUserViewModel] {
        
        guard let exploreData = parseJSON() else {return []}
        
        return exploreData.recommended.compactMap {
            
            ExploreUserViewModel(profilePic: UIImage(named: $0.profilePicture), username: $0.username, followerCount: $0.followerCount) {}
        }
        
    }
    
    /// Get featured section data
    /// - Returns: array of featured view models
    public func getExploreRecent() -> [ExploreFeaturedViewModel] {
        
        guard let exploreData = parseJSON() else {return []}
        
        return exploreData.recent.compactMap {
            
            ExploreFeaturedViewModel(image: UIImage(named: $0.image), caption: $0.caption) {}
        }
        
    }
    

    
    /// Parsing local Data.json file
    /// - Returns: view model data for each section
    private func parseJSON() -> ExploreResponse? {
            
        guard let path = Bundle.main.path(forResource: "Data", ofType: "json") else {
            print("Error: Data.json not found")
            return nil
        }
        
        do {
            
            let url = URL(fileURLWithPath: path)
            
            let data = try Data(contentsOf: url)
            
            return try JSONDecoder().decode(ExploreResponse.self, from: data)
            
            
        } catch {
            
            print(error.localizedDescription)
            return nil
            
        }
    }
}
