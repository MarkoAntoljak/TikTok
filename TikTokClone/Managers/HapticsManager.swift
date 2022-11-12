//
//  HapticsManager.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import Foundation
import UIKit

final class HapticsManager {
    
    // MARK: Attributes
    
    public static let shared = HapticsManager()
    
    private init() {}
    
    // MARK: Functions
    
    public func vibrateForSelection() {
        
        DispatchQueue.main.async {
            
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
            
        }
        
    }
    
    // vibrate feedback  success, warning and error
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        
        DispatchQueue.main.async {
            
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
            
        }
        
    }

    
    
}
