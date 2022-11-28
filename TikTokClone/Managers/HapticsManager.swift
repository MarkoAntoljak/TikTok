//
//  HapticsManager.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import Foundation
import UIKit


/// Manager for vibrate haptics
struct HapticsManager {
    
    // MARK: Attributes
    /// singleton
    public static let shared = HapticsManager()
    
    private init() {}
    
    // MARK: Functions
    
    
    /// Vibrating for error or success
    /// - Parameter type: type of vibrate
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        
        DispatchQueue.main.async {
            
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
            
        }
        
    }

    
    
}
