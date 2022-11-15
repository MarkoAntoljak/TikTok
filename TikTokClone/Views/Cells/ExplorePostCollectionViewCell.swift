//
//  ExplorePostCollectionViewCell.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/14/22.
//

import UIKit

class ExplorePostCollectionViewCell: UICollectionViewCell {
    
    // MARK: Propreties
    
    static let identifier = "ExplorePostCollectionViewCell"
    
    // MARK: UI Elements
    
    private lazy var imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 10
        imageview.layer.masksToBounds = true
        return imageview
    }()

    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.clipsToBounds = true
        
        imageView.frame = contentView.bounds
        
        addSubview(imageView)
    
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentView.height)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        
    }
    
    // MARK: Functions
    
    func configure(with viewModel: ExplorePostViewModel) {
        
        imageView.image = viewModel.image
    
    }
    
    
}
