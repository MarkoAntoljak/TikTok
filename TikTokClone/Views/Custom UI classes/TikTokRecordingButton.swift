//
//  TikTokRecordingButton.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/19/22.
//

import UIKit

enum ButtonState {
    
    case recording
    
    case notRecording
}

class TikTokRecordingButton: UIButton {

    
    // MARK: Attributes
        
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = nil
        layer.masksToBounds = true
        layer.borderWidth = 5
        layer.borderColor = UIColor.white.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = height / 2
    }
    
    // MARK: Functions
    func toggle(for state: ButtonState) {
        
        switch state {
        
        case .recording:
            backgroundColor = .systemRed
            layer.borderColor = nil
        case .notRecording:
            backgroundColor = nil
            layer.borderColor = UIColor.white.cgColor
        }
    }

    
    


}
