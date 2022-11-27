//
//  Extensions.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/11/22.
//

import Foundation
import UIKit


/// extension of UIView class for simpler use
extension UIView {
    
    var width: CGFloat {
        
        return frame.size.width
    }
    
    var height: CGFloat {
        
        return frame.size.height
    }
    
    var left: CGFloat {
        
        return frame.origin.x
    }
    
    var right: CGFloat {
        
        return left + width
    }
    
    var bottom: CGFloat {
        
        return top + height
    }
    
    var top: CGFloat {
        
        return frame.origin.y
    }
    
}
