//
//  TikTokTextField.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/17/22.
//

import UIKit

class TikTokTextField: UITextField {
    
    // MARK: Attributes
    
    enum TFType {
        
        case email
        case password
        
    }
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
}
