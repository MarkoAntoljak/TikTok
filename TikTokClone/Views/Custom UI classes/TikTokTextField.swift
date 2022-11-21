//
//  TikTokTextField.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/17/22.
//

import UIKit

// custom textfield cell used on sign in and sign up
class TikTokTextField: UITextField {

    // MARK: Init
    init() {
        
        super.init(frame: .zero)
        
        // styling
        textColor = .label
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 10
        frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: height))
        leftViewMode = .always
        autocorrectionType = .no
        autocapitalizationType = .none
        layer.masksToBounds = true
        
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
