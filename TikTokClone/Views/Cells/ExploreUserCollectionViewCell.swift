//
//  ExploreUserCollectionViewCell.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/14/22.
//

import UIKit

class ExploreUserCollectionViewCell: UICollectionViewCell {
    
    // MARK: Propreties
    
    static let identifier = "ExploreUserCollectionViewCell"
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: Functions
    
    func configure(with viewModel: ExploreUserViewModel) {
        
        
    }
}
